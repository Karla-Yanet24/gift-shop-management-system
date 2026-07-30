/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.edu.pe.modelo;


/**
 * Representa una línea de detalle dentro de un pedido
 * (qué producto, cuántas unidades, a qué precio).
 *
 * NOTA: PagMisPedidos.jsp originalmente usaba ${detalle.Importe()} con
 * paréntesis, que no es válido en EL estándar. Aquí se expone como
 * propiedad getImporte() para usarse como ${detalle.importe}.
 */
public class DetallePedido {

    private int idDetalle;
    private int idPedido;
    private Producto producto;
    private int cantidad;
    private double precioUnitario;
    private String dedicatoria;

    public String getDedicatoria() {
        return dedicatoria;
    }

    public void setDedicatoria(String dedicatoria) {
        this.dedicatoria = dedicatoria;
    }

    public DetallePedido() {}

    public DetallePedido(Producto producto, int cantidad) {
        this.producto = producto;
        this.cantidad = cantidad;
        this.precioUnitario = producto.getPrecio().doubleValue();
    }

    public int getIdDetalle() {
        return idDetalle;
    }

    public void setIdDetalle(int idDetalle) {
        this.idDetalle = idDetalle;
    }

    public Producto getProducto() {
        return producto;
    }

    public void setProducto(Producto producto) {
        this.producto = producto;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
    }

    public double getPrecioUnitario() {
        return precioUnitario;
    }

    public void setPrecioUnitario(double precioUnitario) {
        this.precioUnitario = precioUnitario;
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }
    
    /** Incrementa la cantidad (usado por Carrito.AgregarCarrito cuando el producto ya estaba). */
    public void aumentarCantidad(int unidadesAdicionales) {
        this.cantidad += unidadesAdicionales;
    }
 
    /** Subtotal de esta línea: precio unitario x cantidad. Usado por Carrito.ImporteTotal. */
    public double calcularImporte() {
        return precioUnitario * cantidad;
    }
 
    /** Alias de calcularImporte(), para usarse como ${detalle.importe} en JSP (EL no admite paréntesis). */
    public double getImporte() {
        return calcularImporte();
    }
 
    /** Alias de calcularImporte(), para compatibilidad con ${item.subtotal} si se usa ese nombre en JSP. */
    public double getSubtotal() {
        return calcularImporte();
    }
    
}