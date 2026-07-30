
package com.edu.pe.modelo;

import java.time.LocalDateTime;



public class Cliente {
    private int idCliente;
    private String nombres;
    private String apellidos;
    private String telefono;
    private String correo;
    private String password;
    private String distrito;
    private String rol;           // "user" o "admin"
    private LocalDateTime fechaRegistro;

    public Cliente() {
        this.rol = "usuario";
    }
     
    public String getRol() { 
        return rol; 
    }
    
    public void setRol(String rol) { 
        this.rol = rol; 
    }
 
    public LocalDateTime getFechaRegistro() { 
        return fechaRegistro; 
    }
    
    public void setFechaRegistro(LocalDateTime fechaRegistro) { 
        this.fechaRegistro = fechaRegistro; 
    }
    
    public String getDistrito() {
        return distrito;
    }

    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }

    public Cliente(int idCliente, String nombres, String apellidos, String telefono, String correo, String password, String direccionEntrega, String referencia, String distrito) {
        this.idCliente = idCliente;
        this.nombres = nombres;
        this.apellidos = apellidos;
        this.telefono = telefono;
        this.correo = correo;
        this.password = password;
        this.distrito = distrito;
    }

    
    
    public String getnombresCompletos(){
        return (nombres + " " + apellidos).toUpperCase();
    }

    
    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public String getNombres() {
        return nombres;
    }

    public void setNombres(String nombres) {
        this.nombres = nombres;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getTelefono() {
        return telefono;
    }

    public void setTelefono(String telefono) {
        this.telefono = telefono;
    }

    public String getCorreo() {
        return correo;
    }

    public void setCorreo(String correo) {
        this.correo = correo;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    
}
