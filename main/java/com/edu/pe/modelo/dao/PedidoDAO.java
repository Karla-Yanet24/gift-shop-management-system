/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.modelo.dao;

import com.edu.pe.config.Conexion;
import com.edu.pe.modelo.DetallePedido;
import com.edu.pe.modelo.Pedido;
import com.edu.pe.modelo.Producto;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Acceso a datos para pedidos y detalle_pedido.
 *
 * El registro de un pedido es una operación TRANSACCIONAL: se inserta el
 * pedido, se insertan sus detalles y se descuenta el stock de cada producto.
 * Si cualquier paso falla (p. ej. no hay stock suficiente), se hace rollback
 * completo para no dejar datos inconsistentes (RF02.4 / RNF02.2).
 */
public class PedidoDAO {

    /**
     * Registra un pedido completo a partir del carrito de compras.
     *
     * @return el id del pedido generado
     * @throws SQLException        si ocurre un error de base de datos
     * @throws StockInsuficienteException si algún producto no tiene stock suficiente
     */
    public int registrarPedido(int idCliente, List<DetallePedido> carrito, String metodoPago, String comprobantePago, String direccionEntrega, String observaciones, double totalFinal)
            throws SQLException, StockInsuficienteException {

        Connection con = null;
        try {
            con = Conexion.getConnection();
            con.setAutoCommit(false);   // inicio de transacción

            // El total final (con delivery y descuentos) es calculado y validado
            // en el controlador antes de llegar aquí; se usa directamente.
            double total = totalFinal;

            int idPedido = insertarPedido(con, idCliente, total, metodoPago, comprobantePago, direccionEntrega, observaciones);
            ProductoDAO productoDAO = new ProductoDAO();
            for (DetallePedido item : carrito) {
                Producto prod = item.getProducto();

                boolean stockOk = productoDAO.descontarStock(prod.getIdProd(), item.getCantidad(), con);
                if (!stockOk) {
                    throw new StockInsuficienteException(
                        "Stock insuficiente para el producto: " + prod.getNombre());
                }

                insertarDetalle(con, idPedido, prod.getIdProd(), item.getCantidad(), item.getPrecioUnitario(), item.getDedicatoria());
            }

            con.commit();
            return idPedido;

        } catch (SQLException | StockInsuficienteException e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException ignored) {}
            }
            throw e;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ignored) {}
                Conexion.cerrar(con);
            }
        }
    }

    private int insertarPedido(Connection con, int idCliente, double total, String metodoPago, String comprobantePago,
                                String direccionEntrega, String observaciones) throws SQLException {
        String sql = "INSERT INTO pedidos (id_cliente, total, estado, metodo_pago, comprobante_pago, direccion_entrega, observaciones) " +
                     "VALUES (?, ?, 'Pendiente', ?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idCliente);
            ps.setDouble(2, total);
            ps.setString(3, metodoPago);
            ps.setString(4, comprobantePago);
            ps.setString(5, direccionEntrega);
            ps.setString(6, observaciones);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private void insertarDetalle(Connection con, int idPedido, int idProducto, int cantidad,
                                  double precioUnitario, String dedicatoria) throws SQLException {
        String sql = "INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario, subtotal, dedicatoria) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        double subtotal = precioUnitario * cantidad;
        
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setDouble(4, precioUnitario);
            ps.setDouble(5, subtotal);
            ps.setString(6, dedicatoria);
            ps.executeUpdate();
        }
    }

    /** Lista el historial de pedidos de un cliente, con sus detalles cargados. */
    public List<Pedido> listarPorCliente(int idCliente) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT id_pedido, id_cliente, fecha_pedido, total, estado, metodo_pago, comprobante_pago, " +
                     "       direccion_entrega, observaciones " +
                     "FROM pedidos WHERE id_cliente = ? ORDER BY fecha_pedido DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idCliente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pedidos.add(mapearPedido(rs));
                }
            }

            for (Pedido p : pedidos) {
                p.setDetalles(listarDetalles(con, p.getIdPedido()));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar pedidos del cliente: " + e.getMessage(), e);
        }
        return pedidos;
    }

    /** Lista todos los pedidos del sistema (para el panel administrativo). */
    public List<Pedido> listarTodos() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT id_pedido, id_cliente, fecha_pedido, total, estado, metodo_pago, comprobante_pago, " +
                     "       direccion_entrega, observaciones " +
                     "FROM pedidos ORDER BY fecha_pedido DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                pedidos.add(mapearPedido(rs));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar pedidos: " + e.getMessage(), e);
        }
        return pedidos;
    }

    /** Actualiza el estado de un pedido (Pendiente -> Preparando -> Enviado -> Entregado). */
    public boolean actualizarEstado(int idPedido, String nuevoEstado) {
        String sql = "UPDATE pedidos SET estado = ? WHERE id_pedido = ?";
        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, nuevoEstado);
            ps.setInt(2, idPedido);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error al actualizar estado del pedido: " + e.getMessage(), e);
        }
    }

    private List<DetallePedido> listarDetalles(Connection con, int idPedido) throws SQLException {
        List<DetallePedido> detalles = new ArrayList<>();
        String sql = "SELECT d.id_detalle, d.cantidad, d.precio_unitario, d.subtotal, d.dedicatoria, " +
                     "       pr.id_producto, pr.nombre, pr.imagen, pr.precio " +
                     "FROM detalle_pedido d " +
                     "JOIN productos pr ON d.id_producto = pr.id_producto " +
                     "WHERE d.id_pedido = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idPedido);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    
                    DetallePedido d = new DetallePedido();
                    d.setIdDetalle(rs.getInt("id_detalle"));
                    d.setIdPedido(idPedido);
                    d.setCantidad(rs.getInt("cantidad"));
                    d.setPrecioUnitario(rs.getDouble("precio_unitario"));
                    d.setDedicatoria(rs.getString("dedicatoria"));
                   

                    Producto p = new Producto();
                    p.setIdProd(rs.getInt("id_producto"));
                    p.setNombre(rs.getString("nombre"));
                    p.setImagen(rs.getString("imagen"));
                    p.setPrecio(rs.getBigDecimal("precio"));
                    d.setProducto(p);

                    detalles.add(d);
                }
            }
        }
        return detalles;
    }

    private Pedido mapearPedido(ResultSet rs) throws SQLException {
        Pedido p = new Pedido();
        p.setIdPedido(rs.getInt("id_pedido"));
        p.setIdCliente(rs.getInt("id_cliente"));
        p.setFecha(rs.getTimestamp("fecha_pedido").toLocalDateTime());
        p.setTotal(rs.getDouble("total"));
        p.setEstado(rs.getString("estado"));
        p.setMetodoPago(rs.getString("metodo_pago"));
        p.setComprobantePago(rs.getString("comprobante_pago"));
        p.setDireccionEntrega(rs.getString("direccion_entrega"));
        p.setObservaciones(rs.getString("observaciones"));
        return p;
    }

    /** Excepción específica para cuando no hay stock suficiente al confirmar un pedido. */
    public static class StockInsuficienteException extends Exception {
        public StockInsuficienteException(String mensaje) {
            super(mensaje);
        }
    }
    
    /** Lista todos los pedidos con el nombre del cliente, para el panel administrativo. */
    public List<Pedido> listarTodosConCliente() {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT p.id_pedido, p.id_cliente, p.fecha_pedido, p.total, p.estado, p.metodo_pago, p.comprobante_pago, " +
                     "       p.direccion_entrega, p.observaciones, " +
                     "       CONCAT(c.nombres, ' ', c.apellidos) AS nombre_cliente " +
                     "FROM pedidos p " +
                     "JOIN clientes c ON p.id_cliente = c.id_cliente " +
                     "ORDER BY p.fecha_pedido DESC";

        try (Connection con = Conexion.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Pedido p = mapearPedido(rs);
                p.setNombreCliente(rs.getString("nombre_cliente"));
                pedidos.add(p);
            }

            for (Pedido p : pedidos) {
                p.setDetalles(listarDetalles(con, p.getIdPedido()));
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error al listar pedidos con cliente: " + e.getMessage(), e);
        }
        return pedidos;
    }
    
}