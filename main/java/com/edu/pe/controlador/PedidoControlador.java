package com.edu.pe.controlador;

import com.edu.pe.app.util.Carrito;
import com.edu.pe.modelo.Cliente;
import com.edu.pe.modelo.DetallePedido;
import com.edu.pe.modelo.Pedido;
import com.edu.pe.modelo.dao.PedidoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Part;
import java.io.File;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Controlador de pedidos.
 * - procesar   (POST, desde PagCarrito.jsp) :  confirma la compra del carrito actual
 * - misPedidos (GET, desde Navegacion.jsp)   : historial de pedidos del cliente logueado
 */

@WebServlet(name = "PedidoControlador", urlPatterns = {"/PedidoControlador"})
@MultipartConfig(
    fileSizeThreshold = 0,
    maxFileSize = 5242880,
    maxRequestSize = 10485760
)
public class PedidoControlador extends HttpServlet {

    private PedidoDAO pedidoDao = new PedidoDAO();
    private Carrito carritoUtil = new Carrito();
    
    // Carpeta real donde se guardan los pagos subidos (dentro del webapp desplegado)
    private static final String CARPETA_COMPROBANTES = "C:/FloreriaUploads/comprobantes/";

    // ── Tabla de costos de delivery por distrito (debe coincidir con el JS del JSP) ──
    private static final Map<String, Double> DELIVERY_POR_DISTRITO = Map.ofEntries(
        // Zona Gratuita
        Map.entry("Miraflores",            0.0),
        Map.entry("San Isidro",            0.0),
        Map.entry("San Borja",             0.0),
        Map.entry("Surco",                 0.0),
        Map.entry("La Molina",             0.0),
        // Zona Básica
        Map.entry("Lince",                 5.0),
        Map.entry("Jesús María",           5.0),
        Map.entry("Magdalena del Mar",     5.0),
        Map.entry("San Miguel",            5.0),
        Map.entry("Pueblo Libre",          5.0),
        Map.entry("Barranco",              5.0),
        Map.entry("Chorrillos",            5.0),
        Map.entry("Surquillo",             5.0),
        // Zona Estándar
        Map.entry("Ate",                   10.0),
        Map.entry("La Victoria",           10.0),
        Map.entry("El Agustino",           10.0),
        Map.entry("Santa Anita",           10.0),
        Map.entry("San Luis",              10.0),
        Map.entry("Cercado de Lima",       10.0),
        Map.entry("Breña",                 10.0),
        Map.entry("Rímac",                 10.0),
        Map.entry("San Martín de Porres",  10.0),
        Map.entry("Los Olivos",            10.0),
        Map.entry("Independencia",         10.0),
        Map.entry("Comas",                 10.0),
        // Zona Extendida
        Map.entry("San Juan de Lurigancho", 15.0),
        Map.entry("Villa El Salvador",      15.0),
        Map.entry("Villa María del Triunfo",15.0),
        Map.entry("Lurín",                  15.0),
        Map.entry("Pachacámac",             15.0),
        Map.entry("Puente Piedra",          15.0),
        Map.entry("Carabayllo",             15.0),
        Map.entry("Ancón",                  15.0),
        Map.entry("Santa Rosa",             15.0),
        Map.entry("Chaclacayo",             15.0),
        Map.entry("Cieneguilla",            15.0),
        Map.entry("Punta Hermosa",          15.0),
        Map.entry("Punta Negra",            15.0),
        Map.entry("San Bartolo",            15.0),
        Map.entry("Santa María del Mar",    15.0),
        Map.entry("Pucusana",               15.0)
    );

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
 
        if ("mis_pedidos".equals(accion)) {
            misPedidos(request, response);
        } else {
            response.sendRedirect("InicioControlador");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
 
        if ("procesar".equals(accion)) {
            procesar(request, response);
        } else {
            response.sendRedirect("CarritoControlador?accion=listar");
        }
    }

    @SuppressWarnings("unchecked")
    private void procesar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sesion = req.getSession();
        
        Cliente usuario = (Cliente) sesion.getAttribute("usuario");
 
        // Solo clientes logueados pueden confirmar un pedido
        if (usuario == null) {
            sesion.setAttribute("error", "Debes iniciar sesión para procesar tu compra.");
            resp.sendRedirect("AuthControlador?accion=login");
            return;
        }
 
        List<DetallePedido> carrito = (List<DetallePedido>) sesion.getAttribute("carrito");
        if (carrito == null || carrito.isEmpty()) {
            sesion.setAttribute("error", "Tu carrito está vacío.");
            resp.sendRedirect("CarritoControlador?accion=listar");
            return;
        }

        // ── Leer campos de dirección (nuevo: distrito + calle) ──
        String distritoDelivery = req.getParameter("distritoDelivery");
        String direccionCalle   = req.getParameter("direccionCalle");

        // Construir dirección completa combinando distrito y calle
        String direccionEntrega;
        if (distritoDelivery != null && !distritoDelivery.trim().isEmpty()) {
            direccionEntrega = distritoDelivery.trim();
            if (direccionCalle != null && !direccionCalle.trim().isEmpty()) {
                direccionEntrega += ", " + direccionCalle.trim();
            }
        } else {
            // Respaldo: usar el campo antiguo o el distrito registrado del cliente
            direccionEntrega = req.getParameter("direccionEntrega");
            if (direccionEntrega == null || direccionEntrega.trim().isEmpty()) {
                direccionEntrega = usuario.getDistrito();
            }
        }

        // ── Leer campos de personalización (nuevo) ──
        String personalizacion    = req.getParameter("personalizacion");
        String fechaEntrega       = req.getParameter("fechaEntrega");
        String observacionesUser  = req.getParameter("observaciones_usuario");

        // ── Método de pago ──
        String metodoPago = req.getParameter("metodoPago");
        if (metodoPago == null || metodoPago.trim().isEmpty()) {
            metodoPago = "Efectivo";
        }

        // ── Leer dedicatorias del formulario: dedicatoria_0, dedicatoria_1, etc. ──
        for (int i = 0; i < carrito.size(); i++) {
            String ded = req.getParameter("dedicatoria_" + i);
            if (ded != null && !ded.trim().isEmpty()) {
                carrito.get(i).setDedicatoria(ded.trim());
            } else {
                carrito.get(i).setDedicatoria(null);
            }
        }

        // ── Calcular totales en el backend (validación del cálculo del cliente) ──
        String cupon = req.getParameter("cupon");
        double subtotalProductos = 0;
        for (DetallePedido item : carrito) {
            subtotalProductos += item.calcularImporte();
        }
        double costoDelivery = calcularDelivery(distritoDelivery);
        double descuentoCupon = "PRIMAVERA10".equalsIgnoreCase(
                cupon != null ? cupon.trim() : "") ? subtotalProductos * 0.10 : 0;
        double totalFinal = subtotalProductos + costoDelivery - descuentoCupon;

        // ── Concatenar datos de personalización en el campo "observaciones" ──
        // Estrategia: usa etiquetas legibles para no alterar la tabla MySQL
        StringBuilder obs = new StringBuilder();
        if (fechaEntrega != null && !fechaEntrega.trim().isEmpty()) {
            obs.append("[Entrega: ").append(fechaEntrega.trim()).append("] ");
        }
        if (personalizacion != null && !personalizacion.trim().isEmpty()) {
            obs.append("[Personalización: ").append(personalizacion.trim()).append("] ");
        }
        if (observacionesUser != null && !observacionesUser.trim().isEmpty()) {
            obs.append("[Obs: ").append(observacionesUser.trim()).append("]");
        }
        String observaciones = obs.toString().trim();

        // ── Procesar comprobante de pago ──
        String comprobantePago = null;
        try {
            Part part = req.getPart("comprobante");
            if (part != null && part.getSize() > 0) {
                String original = part.getSubmittedFileName();
                String extension = "";
                if (original != null && original.contains(".")) {
                    extension = original.substring(original.lastIndexOf('.'));
                }
                comprobantePago = UUID.randomUUID().toString() + extension;

                File carpeta = new File(CARPETA_COMPROBANTES);
                if (!carpeta.exists()) {
                    carpeta.mkdirs();
                }
                Path destino = new File(carpeta, comprobantePago).toPath();
                try (var input = part.getInputStream()) {
                    Files.copy(input, destino);
                }
            }
        } catch (Exception e) {
            System.out.println("ERROR al subir comprobante: " + e.getMessage());
            e.printStackTrace();
            // Si falla la subida del comprobante, el pedido igual continúa
            comprobantePago = null;
        }
        
        // ── Registrar pedido con el total final calculado ──
        try {
            int idPedido = pedidoDao.registrarPedido(
                usuario.getIdCliente(), carrito, metodoPago, comprobantePago,
                direccionEntrega, observaciones, totalFinal);

            sesion.removeAttribute("carrito");   // vaciar carrito tras compra exitosa
            sesion.setAttribute("success", "¡Pedido #" + idPedido + " registrado con éxito!");
            resp.sendRedirect("PedidoControlador?accion=mis_pedidos");

        } catch (PedidoDAO.StockInsuficienteException e) {
            sesion.setAttribute("error", e.getMessage());
            resp.sendRedirect("CarritoControlador?accion=listar");
        } catch (SQLException e) {
            sesion.setAttribute("error", "Ocurrió un error al procesar tu pedido. Intenta nuevamente.");
            resp.sendRedirect("CarritoControlador?accion=listar");
        }
    }

    /**
     * Calcula el costo de delivery según el distrito seleccionado.
     * Devuelve 0 si el distrito no está en el mapa (por seguridad).
     */
    private double calcularDelivery(String distrito) {
        if (distrito == null || distrito.trim().isEmpty()) {
            return 0.0;
        }
        return DELIVERY_POR_DISTRITO.getOrDefault(distrito.trim(), 0.0);
    }
        
 
    private void misPedidos(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
 
        HttpSession sesion = req.getSession();
        Cliente usuario = (Cliente) sesion.getAttribute("usuario");
 
        if (usuario == null) {
            sesion.setAttribute("error", "Debes iniciar sesión para ver tus pedidos.");
            resp.sendRedirect("AuthControlador?accion=login");
            return;
        }
 
        List<Pedido> pedidos = pedidoDao.listarPorCliente(usuario.getIdCliente());
        req.setAttribute("pedidos", pedidos);
        req.getRequestDispatcher("PagMisPedidos.jsp").forward(req, resp);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
