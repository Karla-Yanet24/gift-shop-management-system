
package com.edu.pe.config;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;



public class Conexion {
    private static String database = "floreria_primavera";
    private static String username = "your_username";
    private static String password = "your_password";
    private static String url = "jdbc:mysql://localhost/" + database;
    
    public static Connection getConnection(){
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);
            System.out.println("Conexión Establecida");
        } catch (Exception ex) {
            ex.printStackTrace();
            
        }
        return conn;
        
        
    }
    
    /** Cierra la conexión de forma segura, ignorando errores. */
    public static void cerrar(Connection con) {
        if (con != null) {
            try {
                con.close();
            } catch (SQLException ignored) {
                // No se propaga: cerrar nunca debe romper el flujo principal
            }
        }
    }
    
}
