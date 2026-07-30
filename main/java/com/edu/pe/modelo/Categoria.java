/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.modelo;

/**
 *
 * @author USUARIO
 */
public class Categoria {
 
    private int idCategoria;
    private String nombre;
    private String descripcion;
    private boolean estado;
    private boolean permiteDedicatoria;

    public boolean isPermiteDedicatoria() {
        return permiteDedicatoria;
    }

    public void setPermiteDedicatoria(boolean permiteDedicatoria) {
        this.permiteDedicatoria = permiteDedicatoria;
    }
    
    public Categoria() {
        this.estado = true;
    }
 
    public Categoria(int idCategoria, String nombre) {
        this.idCategoria = idCategoria;
        this.nombre = nombre;
    }
 
    public int getIdCategoria() { 
        return idCategoria; 
    }
    
    public void setIdCategoria(int idCategoria) { 
        this.idCategoria = idCategoria; 
    }
 
    public String getNombre() { 
        return nombre; 
    }
    
    public void setNombre(String nombre) { 
        this.nombre = nombre; 
    }
 
    public String getDescripcion() { 
        return descripcion; 
    }
    
    public void setDescripcion(String descripcion) { 
        this.descripcion = descripcion; 
    }
 
    public boolean isEstado() { 
        return estado; 
    }
    
    public void setEstado(boolean estado) { 
        this.estado = estado; 
    }
 
    @Override
    public String toString() {
        return nombre;
    }
}