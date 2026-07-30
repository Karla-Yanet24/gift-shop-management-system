
package com.edu.pe.modelo;

import java.math.BigDecimal;



public class Producto {

    private int idProd;
    private String nombre;
    private String descripcion;
    private BigDecimal precio;
    private int stock;
    private String imagen;
    private boolean estado;
    private Categoria categoriaObj;


    public Producto() {
        this.precio = BigDecimal.ZERO;
        this.estado = true;
        this.categoriaObj = new Categoria();
    }

     

    public int getIdProd() {
        return idProd;
    }

    public void setIdProd(int idProd) {
        this.idProd = idProd;
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

    public BigDecimal getPrecio() {
        return precio;
    }

    public void setPrecio(BigDecimal precio) {
        this.precio = precio;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getImagen() {
        return imagen;
    }

    public void setImagen(String imagen) {
        this.imagen = imagen;
    }
    
    public boolean isEstado() { 
        return estado; 
    }
    
    public void setEstado(boolean estado) { 
        this.estado = estado; 
    }
 
    /** Objeto Categoria completo (id + nombre). Usado por el select del formulario. */
    
    public Categoria getCategoriaObj() { 
        return categoriaObj; 
    }
    
    public void setCategoriaObj(Categoria categoriaObj) { 
        this.categoriaObj = categoriaObj; 
    }
 
    /**
     * Devuelve el NOMBRE de la categoría.
     * Mantiene compatible la expresión ${p.categoria} usada en los JSP existentes.
     */
    public String getCategoria() {
        return categoriaObj != null ? categoriaObj.getNombre() : "";
    }
 
    /** Id de categoría, usado al guardar el producto desde el formulario. */
    public int getIdCategoria() {
        return categoriaObj != null ? categoriaObj.getIdCategoria() : 0;
    }
 
    public void setIdCategoria(int idCategoria) {
        if (this.categoriaObj == null) {
            this.categoriaObj = new Categoria();
        }
        this.categoriaObj.setIdCategoria(idCategoria);
    }
}
