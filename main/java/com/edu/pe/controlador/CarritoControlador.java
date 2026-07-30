/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.app.util.Carrito;
import com.edu.pe.modelo.DetallePedido;
import com.edu.pe.modelo.Producto;
import com.edu.pe.modelo.dao.ProductoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.ArrayList;

/**
 *
 * @author USER
 */
public class CarritoControlador extends HttpServlet {

    private String PagListarCarrito = "PagCarrito.jsp";


    private ProductoDAO prodDao = new ProductoDAO();
    private Carrito objCarrito = new Carrito();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String accion = request.getParameter("accion");
        switch (accion) {
            case "listar":
                Listar(request, response);
                break;
            case "agregar":
                Agregar(request, response);
                break;
            case "eliminar":
                Eliminar(request, response);
                break;
            case "aumentar":
                Aumentar(request, response);
                break;
            case "disminuir":
                Disminuir(request, response);
                break;
            default:
                throw new AssertionError();
        }
    }

    protected void Agregar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        int ipProd = Integer.parseInt(request.getParameter("id"));
        Producto obj = prodDao.buscarPorId(ipProd);

        if (obj != null) {
            DetallePedido objDet = new DetallePedido();
            objDet.setProducto(obj);
            objDet.setCantidad(1);
            objDet.setPrecioUnitario(obj.getPrecio().doubleValue());
            objCarrito.AgregarCarrito(objDet, request);

        }
        // Importante: se redirige al servlet de inicio (NO directo a index.jsp),
        // porque index.jsp necesita el atributo "productos" ya cargado, y eso
        // solo lo prepara InicioControlador.
        response.sendRedirect("InicioControlador");
    }

    protected void Listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        ArrayList<DetallePedido> lista = objCarrito.ObtenerSesion(request);
        request.setAttribute("carrito", lista);
        request.setAttribute("total", objCarrito.ImporteTotal(lista));
        request.getRequestDispatcher(PagListarCarrito).forward(request, response);
    }

    protected void Eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int indice = Integer.parseInt(request.getParameter("indice"));

        objCarrito.RemoverItemCarrito(request, indice);

        response.sendRedirect("CarritoControlador?accion=listar");
    }
    
     /** Incrementa en 1 la cantidad de la línea indicada por índice, respetando el stock disponible. */
    protected void Aumentar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int indice = Integer.parseInt(request.getParameter("indice"));
 
        ArrayList<DetallePedido> lista = objCarrito.ObtenerSesion(request);
 
        if (indice >= 0 && indice < lista.size()) {
            DetallePedido item = lista.get(indice);
            int stockDisponible = item.getProducto().getStock();
 
            if (item.getCantidad() + 1 <= stockDisponible) {
                item.aumentarCantidad(1);
                lista.set(indice, item);
                objCarrito.GuardarSesion(request, lista);
            } else {
                request.getSession().setAttribute("error",
                    "No hay más stock disponible de '" + item.getProducto().getNombre() + "'.");
            }
        }
 
        response.sendRedirect("CarritoControlador?accion=listar");
    }
    
    /** Disminuye en 1 la cantidad de la línea indicada por índice. Si llega a 0, elimina la línea. */
    protected void Disminuir(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        int indice = Integer.parseInt(request.getParameter("indice"));
 
        ArrayList<DetallePedido> lista = objCarrito.ObtenerSesion(request);
 
        if (indice >= 0 && indice < lista.size()) {
            DetallePedido item = lista.get(indice);
 
            if (item.getCantidad() > 1) {
                item.setCantidad(item.getCantidad() - 1);
                lista.set(indice, item);
                objCarrito.GuardarSesion(request, lista);
            } else {
                lista.remove(indice);
                objCarrito.GuardarSesion(request, lista);
            }
        }
 
        response.sendRedirect("CarritoControlador?accion=listar");
    }
    

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
