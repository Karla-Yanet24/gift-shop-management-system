package com.edu.pe.modelo.dao;

import com.edu.pe.config.Conexion;
import com.edu.pe.modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClienteDAO {

    private Connection cn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public int Guardar(Cliente obj) {
        int result = 0;
        try {
            cn = Conexion.getConnection();
            String sql = "INSERT INTO clientes(nombres,apellidos,correo,contrasena,telefono,distrito,rol) "
                       + "VALUES (?,?,?,?,?,?,'usuario')";

            ps = cn.prepareStatement(sql);
            ps.setString(1, obj.getNombres().trim());
            ps.setString(2, obj.getApellidos().trim());
            ps.setString(3, obj.getCorreo().trim());
            ps.setString(4, obj.getPassword());
            ps.setString(5, obj.getTelefono().trim());
            ps.setString(6, obj.getDistrito());
            result = ps.executeUpdate();

        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (ps != null) {
                    ps.close();
                }
            } catch (Exception ex) {
            }
        }
        return result;
    }

    public boolean ExisteCorreo(String correo) {
        try {
            cn = Conexion.getConnection();
            String sql = "select count(1) from clientes where correo = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            rs = ps.executeQuery();
            if (rs.next()) {
                return (rs.getInt(1) > 0);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (cn != null) {
                    cn.close();
                }
                if (ps != null) {
                    ps.close();
                }
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ex) {
            }
        }
        return false;
    }

    private Cliente mapear(ResultSet rs) throws SQLException {
        Cliente c = new Cliente();
        c.setIdCliente(rs.getInt("id_cliente"));
        c.setNombres(rs.getString("nombres"));
        c.setApellidos(rs.getString("apellidos"));
        c.setTelefono(rs.getString("telefono"));
        c.setCorreo(rs.getString("correo"));
        c.setDistrito(rs.getString("distrito"));
        c.setRol(rs.getString("rol"));
        java.sql.Timestamp ts = rs.getTimestamp("fecha_registro");
        if (ts != null) {
            c.setFechaRegistro(ts.toLocalDateTime());
        }
        return c;
    }
    
    /** Lista todos los clientes registrados (admin y usuarios), para el panel administrativo. */
    public List<Cliente> ListarTodos() {
        List<Cliente> lista = new ArrayList<>();
        String sql = "SELECT id_cliente, nombres, apellidos, correo, telefono, distrito, rol, fecha_registro " +
                     "FROM clientes ORDER BY fecha_registro DESC";
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = Conexion.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                lista.add(mapear(rs));
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (con != null) con.close();
                if (ps != null) ps.close();
                if (rs != null) rs.close();
            } catch (Exception ex) {
            }
        }
        return lista;
    }
}
