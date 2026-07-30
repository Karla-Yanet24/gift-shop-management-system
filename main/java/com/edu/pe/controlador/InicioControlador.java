/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.modelo.Categoria;
import com.edu.pe.modelo.Producto;
import com.edu.pe.modelo.dao.CategoriaDAO;
import com.edu.pe.modelo.dao.ProductoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author USUARIO
 */
@WebServlet(name = "InicioControlador", urlPatterns = {"/InicioControlador"})
public class InicioControlador extends HttpServlet {
        
    private final ProductoDAO dao = new ProductoDAO();
    private final CategoriaDAO categoriaDao = new CategoriaDAO();

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */ 
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Obtener los productos de la base de datos
        List<Producto> lista = dao.listarTodos();

        // 2. Agrupar por categoría (idCategoria -> lista de productos de esa
        // categoría). LinkedHashMap conserva el orden en que aparece cada
        // categoría por primera vez, y evita cualquier ambigüedad de
        // comparar "categoría anterior" dentro del JSP.
        Map<Integer, List<Producto>> porCategoria = new LinkedHashMap<>();
        for (Producto p : lista) {
            porCategoria
                .computeIfAbsent(p.getIdCategoria(), k -> new java.util.ArrayList<>())
                .add(p);
        }

        // 3. Colocarlos en el scope de la solicitud
        // Map idCategoria -> permite_dedicatoria, para que PagCarrito.jsp
        // sepa qué productos pueden llevar dedicatoria sin hacer otra consulta
        Map<Integer, Boolean> permiteDedicatoria = new java.util.HashMap<>();
        for (Categoria cat : categoriaDao.listar()) {
            permiteDedicatoria.put(cat.getIdCategoria(), cat.isPermiteDedicatoria());
        }
        
        request.setAttribute("productos", lista);
        request.setAttribute("categorias", porCategoria);
        request.setAttribute("permiteDedicatoria", permiteDedicatoria);
        
        // Guardamos el mapa en sesión para que PagCarrito.jsp lo acceda
        // sin necesidad de pasar por InicioControlador cada vez
        request.getSession().setAttribute("permiteDedicatoria", permiteDedicatoria);

        // 4. Enviar al JSP
        request.getRequestDispatcher("index.jsp").forward(request, response);
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
