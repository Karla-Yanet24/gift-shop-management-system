/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.modelo.Cliente;
import com.edu.pe.modelo.dao.ClienteDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Controlador del panel administrativo de clientes. Solo lectura: ver la
 * lista de clientes registrados (nombre, correo, distrito, fecha de registro).
 *
 * Acciones:
 *   - listar (GET) : lista todos los clientes -> listaClientes -> PagAdminClientes.jsp
 *
 * Protegido por FiltroAdmin.
 */
@WebServlet(name = "AdminClienteControlador", urlPatterns = {"/AdminClienteControlador"})
public class AdminClienteControlador extends HttpServlet {

    private final ClienteDAO clienteDao = new ClienteDAO();
    private final String pagListado = "PagAdminClientes.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        Listar(request, response);
    }

    protected void Listar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Cliente> lista = clienteDao.ListarTodos();
        request.setAttribute("listaClientes", lista);
        request.getRequestDispatcher(pagListado).forward(request, response);
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
        return "Admin controlador de clientes (solo lectura)";
    }
}
