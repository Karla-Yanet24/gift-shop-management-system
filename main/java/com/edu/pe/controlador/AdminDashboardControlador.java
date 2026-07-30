/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.edu.pe.controlador;

import com.edu.pe.modelo.Cliente;
import com.edu.pe.modelo.Pedido;
import com.edu.pe.modelo.Producto;
import com.edu.pe.modelo.dao.ClienteDAO;
import com.edu.pe.modelo.dao.PedidoDAO;
import com.edu.pe.modelo.dao.ProductoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Controlador del dashboard administrativo: métricas generales calculadas
 * a partir de los DAOs existentes (sin SQL de agregación nuevo).
 *
 * Atributos que deja para PagAdminDashboard.jsp:
 *   - ventasTotales       (double)  suma de todos los pedidos
 *   - totalPedidos        (int)
 *   - pedidosPendientes   (int)     estado == "Pendiente"
 *   - totalClientes       (int)     rol == "usuario" (no cuenta admins)
 *   - totalProductos      (int)     productos activos
 *   - pedidosPorEstado    (Map<String,Integer>) para el gráfico de barras
 *   - productosStockBajo  (List<Producto>) productos con stock <= UMBRAL_STOCK_BAJO
 */
@WebServlet(name = "AdminDashboardControlador", urlPatterns = {"/AdminDashboardControlador"})
public class AdminDashboardControlador extends HttpServlet {

    private static final int UMBRAL_STOCK_BAJO = 5;

    private final PedidoDAO pedidoDao = new PedidoDAO();
    private final ClienteDAO clienteDao = new ClienteDAO();
    private final ProductoDAO productoDao = new ProductoDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // --- Pedidos: ventas totales, conteo por estado, pendientes ---
        List<Pedido> pedidos = pedidoDao.listarTodosConCliente();

        double ventasTotales = 0;
        Map<String, Integer> pedidosPorEstado = new LinkedHashMap<>();
        pedidosPorEstado.put("Pendiente", 0);
        pedidosPorEstado.put("Preparando", 0);
        pedidosPorEstado.put("Enviado", 0);
        pedidosPorEstado.put("Entregado", 0);
        pedidosPorEstado.put("Cancelado", 0);

        for (Pedido p : pedidos) {
            ventasTotales += p.getTotal();
            pedidosPorEstado.merge(p.getEstado(), 1, Integer::sum);
        }

        int pedidosPendientes = pedidosPorEstado.getOrDefault("Pendiente", 0);

        // --- Clientes: solo cuenta rol "usuario", no admins ---
        List<Cliente> clientes = clienteDao.ListarTodos();
        int totalClientes = 0;
        for (Cliente c : clientes) {
            if (!"admin".equals(c.getRol())) {
                totalClientes++;
            }
        }

        // --- Productos: total + lista de stock bajo ---
        List<Producto> productos = productoDao.listarParaAdmin();
        List<Producto> stockBajo = new ArrayList<>();
        for (Producto prod : productos) {
            if (prod.getStock() <= UMBRAL_STOCK_BAJO) {
                stockBajo.add(prod);
            }
        }

        request.setAttribute("ventasTotales", ventasTotales);
        request.setAttribute("totalPedidos", pedidos.size());
        request.setAttribute("pedidosPendientes", pedidosPendientes);
        request.setAttribute("totalClientes", totalClientes);
        request.setAttribute("totalProductos", productos.size());
        request.setAttribute("pedidosPorEstado", pedidosPorEstado);
        request.setAttribute("productosStockBajo", stockBajo);
        request.setAttribute("umbralStockBajo", UMBRAL_STOCK_BAJO);

        request.getRequestDispatcher("PagAdminDashboard.jsp").forward(request, response);
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
        return "Dashboard administrativo con métricas generales";
    }
}
