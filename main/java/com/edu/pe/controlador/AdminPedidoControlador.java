/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.modelo.Pedido;
import com.edu.pe.modelo.dao.PedidoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Controlador del panel administrativo de pedidos.
 *
 * Acciones:
 *   - listar           (GET)  : lista todos los pedidos -> listaPedidos -> PagAdminPedidos.jsp
 *   - cambiarEstado     (GET)  : actualiza el estado de un pedido (id, estado) y vuelve a listar
 *
 * Protegido por FiltroAdmin (igual que AdminProductoControlador).
 */
@WebServlet(name = "AdminPedidoControlador", urlPatterns = {"/AdminPedidoControlador"})
public class AdminPedidoControlador extends HttpServlet {

    private final PedidoDAO pedidoDao = new PedidoDAO();
    private final String pagListado = "PagAdminPedidos.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "cambiarEstado":
                CambiarEstado(request, response);
                break;
            case "listar":
            default:
                Listar(request, response);
                break;
        }
    }

    protected void Listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Pedido> lista = pedidoDao.listarTodosConCliente();
        request.setAttribute("listaPedidos", lista);
        request.getRequestDispatcher(pagListado).forward(request, response);
    }

    protected void CambiarEstado(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int idPedido = Integer.parseInt(request.getParameter("id"));
        String nuevoEstado = request.getParameter("estado");

        boolean ok = pedidoDao.actualizarEstado(idPedido, nuevoEstado);

        if (ok) {
            request.getSession().setAttribute("mensaje", "Estado del pedido #" + idPedido + " actualizado a " + nuevoEstado + ".");
        } else {
            request.getSession().setAttribute("error", "No se pudo actualizar el estado del pedido.");
        }

        response.sendRedirect("AdminPedidoControlador?accion=listar");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin controlador de pedidos";
    }
}