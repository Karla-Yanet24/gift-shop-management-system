
package com.edu.pe.modelo;


import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 * Representa un pedido realizado por un cliente.
 * Usado por PagMisPedidos.jsp 
 */
public class Pedido {

    public static final String PENDIENTE  = "Pendiente";
    public static final String PREPARANDO = "Preparando";
    public static final String ENVIADO    = "Enviado";
    public static final String ENTREGADO  = "Entregado";
    public static final String CANCELADO  = "Cancelado";

    private int idPedido;
    private int idCliente;
    private String nombreCliente;
    private LocalDateTime fecha;
    private double total;
    private String estado;
    private String metodoPago;
    private String comprobantePago;
    private String direccionEntrega;
    private String observaciones;
    private List<DetallePedido> detalles;

    public Pedido() {
        this.estado = PENDIENTE;
        this.detalles = new ArrayList<>();
    }

    public int getIdPedido() {
        return idPedido;
    }

    public void setIdPedido(int idPedido) {
        this.idPedido = idPedido;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }
    
    public String getNombreCliente() {
        return nombreCliente;
    }
    
    public void setNombreCliente(String nombreCliente) {
        this.nombreCliente = nombreCliente;
    }

    public LocalDateTime getFecha() {
        return fecha;
    }

    public void setFecha(LocalDateTime fecha) {
        this.fecha = fecha;
    }

    public double getTotal() {
        return total;
    }

    public void setTotal(double total) {
        this.total = total;
    }


    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getMetodoPago() {
        return metodoPago;
    }

    public void setMetodoPago(String metodoPago) {
        this.metodoPago = metodoPago;
    }
    
     public String getComprobantePago() {
        return comprobantePago;
    }
     
    public void setComprobantePago(String comprobantePago) {
        this.comprobantePago = comprobantePago;
    }

    public String getDireccionEntrega() {
        return direccionEntrega;
    }

    public void setDireccionEntrega(String direccionEntrega) {
        this.direccionEntrega = direccionEntrega;
    }

    public String getObservaciones() {
        return observaciones;
    }

    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
    }

    public List<DetallePedido> getDetalles() {
        return detalles;
    }

    public void setDetalles(List<DetallePedido> detalles) {
        this.detalles = detalles;
    }
    
    /** Fecha formateada como texto (dd/MM/yyyy HH:mm), lista para usar en JSP sin fmt:formatDate. */
    public String getFechaFormateada() {
        if (fecha == null) {
            return "";
        }
        return fecha.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

}

