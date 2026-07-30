/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.modelo.dao;
/**
 *
 * @author USUARIO
 */
import com.edu.pe.config.Conexion;
import com.edu.pe.modelo.Categoria;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
/**
 * Acceso a datos para la tabla categorias.
 */
public class CategoriaDAO {
    /** Lista todas las categorías activas, ordenadas por nombre. Usado por el catálogo público. */
    public List<Categoria> listar() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre, descripcion, estado, permite_dedicatoria " +
                     "FROM categorias WHERE estado = 1 ORDER BY nombre";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar categorías: " + e.getMessage(), e);
        }
        return lista;
    }

    /** Lista TODAS las categorías (activas e inactivas), para el panel admin. */
    public List<Categoria> listarTodas() {
        List<Categoria> lista = new ArrayList<>();
        String sql = "SELECT id_categoria, nombre, descripcion, estado, permite_dedicatoria " +
                     "FROM categorias ORDER BY id_categoria";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar categorías: " + e.getMessage(), e);
        }
        return lista;
    }

    /** Busca una categoría por su id. Devuelve null si no existe. */
    public Categoria buscarPorId(int idCategoria) {
        String sql = "SELECT id_categoria, nombre, descripcion, estado, permite_dedicatoria " +
                     "FROM categorias WHERE id_categoria = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapear(rs);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al buscar categoría: " + e.getMessage(), e);
        }
        return null;
    }

    /** Inserta una nueva categoría. Devuelve el id generado, o 0 si falló. */
    public int insertar(Categoria c) {
        String sql = "INSERT INTO categorias (nombre, descripcion, estado, permite_dedicatoria) VALUES (?, ?, 1, ?)";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, c.getNombre().trim());
            ps.setString(2, c.getDescripcion());
            ps.setBoolean(3, c.isPermiteDedicatoria());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al insertar categoría: " + e.getMessage(), e);
        }
        return 0;
    }

    /** Actualiza nombre y descripción de una categoría existente. */
    public boolean actualizar(Categoria c) {
        String sql = "UPDATE categorias SET nombre = ?, descripcion = ?, permite_dedicatoria = ? WHERE id_categoria = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, c.getNombre().trim());
            ps.setString(2, c.getDescripcion());
            ps.setBoolean(3, c.isPermiteDedicatoria());
            ps.setInt(4, c.getIdCategoria());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar categoría: " + e.getMessage(), e);
        }
    }

    /** Activa o desactiva una categoría (no se elimina físicamente, por la FK con productos). */
    public boolean cambiarEstado(int idCategoria, boolean nuevoEstado) {
        String sql = "UPDATE categorias SET estado = ? WHERE id_categoria = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setBoolean(1, nuevoEstado);
            ps.setInt(2, idCategoria);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al cambiar estado de categoría: " + e.getMessage(), e);
        }
    }

    /** Cuenta cuántos productos (activos) pertenecen a una categoría. Útil para mostrar en la tabla admin. */
    public int contarProductos(int idCategoria) {
        String sql = "SELECT COUNT(*) FROM productos WHERE id_categoria = ? AND estado = 1";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCategoria);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al contar productos: " + e.getMessage(), e);
        }
        return 0;
    }

    private Categoria mapear(ResultSet rs) throws SQLException {
        Categoria c = new Categoria();
        c.setIdCategoria(rs.getInt("id_categoria"));
        c.setNombre(rs.getString("nombre"));
        c.setDescripcion(rs.getString("descripcion"));
        c.setEstado(rs.getBoolean("estado"));
        c.setPermiteDedicatoria(rs.getBoolean("permite_dedicatoria"));
        return c;
    }
    
    /** Activa o desactiva la dedicatoria para una categoría. */
    public boolean toggleDedicatoria(int idCategoria, boolean permite) {
        String sql = "UPDATE categorias SET permite_dedicatoria = ? WHERE id_categoria = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, permite);
            ps.setInt(2, idCategoria);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar dedicatoria: " + e.getMessage(), e);
        }
    }
    
}
