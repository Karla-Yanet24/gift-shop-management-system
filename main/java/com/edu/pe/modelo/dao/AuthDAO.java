/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.modelo.dao;

import com.edu.pe.config.Conexion;
import com.edu.pe.modelo.Cliente;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



public class AuthDAO {

    private Connection cn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public Cliente Login(String correo, String password) {
        Cliente obj = null;
        try {
            cn = Conexion.getConnection();
            String sql = "select * from clientes where correo = ? and contrasena = ?";
            ps = cn.prepareStatement(sql);
            ps.setString(1, correo);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                obj = new Cliente();
                obj.setIdCliente(rs.getInt("id_cliente"));
                obj.setNombres(rs.getString("nombres"));
                obj.setApellidos(rs.getString("apellidos"));
                obj.setCorreo(rs.getString("correo"));
                obj.setTelefono(rs.getString("telefono"));
                obj.setDistrito(rs.getString("distrito"));
                obj.setRol(rs.getString("rol"));
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
        return obj;
    }
}
