package com.edu.pe.modelo.dao;

import com.edu.pe.modelo.Categoria;
import com.edu.pe.modelo.Producto;
import com.edu.pe.config.Conexion;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos para productos.
 *
 * IMPORTANTE: InicioControlador llama a dao.listarTodos() esperando recibir
 * el catálogo PÚBLICO (solo productos activos). Por eso aquí listarTodos()
 * devuelve solo los activos, y se agrega listarParaAdmin() para el panel
 * administrativo, que sí necesita ver también los inactivos/eliminados.
 */
public class ProductoDAO {

    private static final String SELECT_BASE =
        "SELECT p.id_producto, p.id_categoria, p.nombre, p.descripcion, p.precio, " +
        "       p.stock, p.imagen, p.estado, c.nombre AS nombre_categoria " +
        "FROM productos p " +
        "JOIN categorias c ON p.id_categoria = c.id_categoria ";

    /** Catálogo público: solo productos activos. Usado por InicioControlador. */
    public List<Producto> listarTodos() {
        return listar(SELECT_BASE + "WHERE p.estado = 1 AND c.estado = 1 ORDER BY p.id_categoria, p.nombre");
    }

    /** Para el panel admin: TODOS los productos, activos e inactivos. */
    public List<Producto> listarParaAdmin() {
        return listar(SELECT_BASE + "ORDER BY p.id_producto DESC");
    }

    public List<Producto> buscarPorNombre(String texto) {
        List<Producto> lista = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE p.estado = 1 c.estado = 1 AND p.nombre LIKE ? ORDER BY p.nombre";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + texto + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar productos: " + e.getMessage(), e);
        }
        return lista;
    }

    public List<Producto> filtrarPorCategoria(int idCategoria) {
        List<Producto> lista = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE p.estado = 1 c.estado = 1 AND p.id_categoria = ? ORDER BY p.nombre";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapear(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al filtrar productos: " + e.getMessage(), e);
        }
        return lista;
    }

    private List<Producto> listar(String sql) {
        List<Producto> lista = new ArrayList<>();
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar productos: " + e.getMessage(), e);
        }
        return lista;
    }

    public Producto buscarPorId(int idProd) {
        String sql = SELECT_BASE + "WHERE p.id_producto = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProd);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar producto: " + e.getMessage(), e);
        }
        return null;
    }

    public int insertar(Producto p) {
        String sql = "INSERT INTO productos (id_categoria, nombre, descripcion, precio, stock, imagen, estado) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 1)";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, p.getIdCategoria());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, p.getPrecio());
            ps.setInt(5, p.getStock());
            ps.setString(6, p.getImagen());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar producto: " + e.getMessage(), e);
        }
        return 0;
    }

    public boolean actualizar(Producto p) {
        String sql;
        boolean conImagen = p.getImagen() != null && !p.getImagen().trim().isEmpty();

        if (conImagen) {
            sql = "UPDATE productos SET id_categoria=?, nombre=?, descripcion=?, precio=?, stock=?, imagen=? " +
                  "WHERE id_producto=?";
        } else {
            sql = "UPDATE productos SET id_categoria=?, nombre=?, descripcion=?, precio=?, stock=? " +
                  "WHERE id_producto=?";
        }

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int idx = 1;
            ps.setInt(idx++, p.getIdCategoria());
            ps.setString(idx++, p.getNombre());
            ps.setString(idx++, p.getDescripcion());
            ps.setBigDecimal(idx++, p.getPrecio());
            ps.setInt(idx++, p.getStock());
            if (conImagen) {
                ps.setString(idx++, p.getImagen());
            }
            ps.setInt(idx, p.getIdProd());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar producto: " + e.getMessage(), e);
        }
    }

    /** Eliminación lógica (estado = 0), conserva historial en pedidos pasados. */
    public boolean eliminar(int idProd) {
        String sql = "UPDATE productos SET estado = 0 WHERE id_producto = ?";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idProd);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al eliminar producto: " + e.getMessage(), e);
        }
    }

    /** Descuenta stock dentro de una transacción externa (ver PedidoDAO). */
    public boolean descontarStock(int idProd, int cantidad, Connection con) throws SQLException {
        String sql = "UPDATE productos SET stock = stock - ? WHERE id_producto = ? AND stock >= ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, idProd);
            ps.setInt(3, cantidad);
            return ps.executeUpdate() > 0;
        }
    }

    private Producto mapear(ResultSet rs) throws SQLException {
        Producto p = new Producto();
        p.setIdProd(rs.getInt("id_producto"));
        p.setNombre(rs.getString("nombre"));
        p.setDescripcion(rs.getString("descripcion"));
        p.setPrecio(rs.getBigDecimal("precio"));
        p.setStock(rs.getInt("stock"));
        p.setImagen(rs.getString("imagen"));
        p.setEstado(rs.getBoolean("estado"));

        Categoria cat = new Categoria();
        cat.setIdCategoria(rs.getInt("id_categoria"));
        cat.setNombre(rs.getString("nombre_categoria"));
        p.setCategoriaObj(cat);

        return p;
    }
}