package com.edu.pe.controlador;

import com.edu.pe.modelo.Categoria;
import com.edu.pe.modelo.Producto;
import com.edu.pe.modelo.dao.CategoriaDAO;
import com.edu.pe.modelo.dao.ProductoDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.UUID;

/**
 * Controlador del panel administrativo de productos (CRUD completo).
 *   - listar   (GET)  : listaProductos -> PagAdminProductos.jsp
 *   - nuevo    (GET)  : formulario vacío -> producto, listaCategorias -> FormProducto.jsp
 *   - editar   (GET)  : formulario con datos -> producto, listaCategorias -> FormProducto.jsp
 *   - eliminar (GET)  : elimina (lógicamente) y vuelve a listar
 *   - guardar  (POST) : inserta o actualiza, con imagen (multipart/form-data)
 *
 * Protegido por FiltroAdmin (solo accesible si sessionScope.rol == "admin").
 */
@WebServlet(name = "AdminProductoControlador", urlPatterns = {"/AdminProductoControlador"})
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class AdminProductoControlador extends HttpServlet {

    private final ProductoDAO productoDAO = new ProductoDAO();
    private final CategoriaDAO categoriaDAO = new CategoriaDAO();

    private static final String CARPETA_IMAGENES = "C:/FloreriaUploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String accion = req.getParameter("accion");
        if (accion == null) accion = "listar";

        switch (accion) {
            case "nuevo":
                mostrarFormulario(req, resp, new Producto());
                break;
            case "editar":
                editar(req, resp);
                break;
            case "eliminar":
                eliminar(req, resp);
                break;
            case "listar":
            default:
                listar(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        guardar(req, resp);
    }

    private void listar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Producto> lista = productoDAO.listarParaAdmin();
        req.setAttribute("listaProductos", lista);
        req.getRequestDispatcher("PagAdminProductos.jsp").forward(req, resp);
    }

    private void editar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = parseIntSeguro(req.getParameter("id"), 0);
        Producto producto = productoDAO.buscarPorId(id);

        if (producto == null) {
            req.getSession().setAttribute("error", "El producto solicitado no existe.");
            resp.sendRedirect("AdminProductoControlador?accion=listar");
            return;
        }

        mostrarFormulario(req, resp, producto);
    }

    private void mostrarFormulario(HttpServletRequest req, HttpServletResponse resp, Producto producto)
            throws ServletException, IOException {

        List<Categoria> categorias = categoriaDAO.listar();
        req.setAttribute("producto", producto);
        req.setAttribute("listaCategorias", categorias);
        req.getRequestDispatcher("FormProducto.jsp").forward(req, resp);
    }

    private void eliminar(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = parseIntSeguro(req.getParameter("id"), 0);
        
        if (id > 0) {
             Producto producto = productoDAO.buscarPorId(id);
             
             if (producto != null) {
                 eliminarImagen(producto.getImagen());
                    
                 productoDAO.eliminar(id);
                 req.getSession().setAttribute("success", "Producto eliminado correctamente.");
            }
            resp.sendRedirect("AdminProductoControlador?accion=listar");
        }
    }

    private void guardar(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int id = parseIntSeguro(req.getParameter("id"), 0);

        String nombre = req.getParameter("nombre");
        String descripcion = req.getParameter("descripcion");
        String categoriaParam = req.getParameter("categoria");
        String precioParam = req.getParameter("precio");
        String stockParam = req.getParameter("stock");

        if (esVacio(nombre) || nombre.trim().length() < 2) {
            redirigirConError(req, resp, id, "El nombre debe tener al menos 2 caracteres.");
            return;
        }
        if (esVacio(descripcion) || descripcion.trim().length() < 10) {
            redirigirConError(req, resp, id, "La descripción debe tener al menos 10 caracteres.");
            return;
        }
        if (esVacio(categoriaParam)) {
            redirigirConError(req, resp, id, "Debes seleccionar una categoría.");
            return;
        }

        BigDecimal precio;
        int stock;
        int idCategoria;
        try {
            precio = new BigDecimal(precioParam);
            stock = Integer.parseInt(stockParam);
            idCategoria = Integer.parseInt(categoriaParam);
            if (precio.compareTo(BigDecimal.ZERO) <= 0 || stock < 0) {
                throw new NumberFormatException();
            }
        } catch (NumberFormatException e) {
            redirigirConError(req, resp, id, "Precio o stock inválido.");
            return;
        }

        Producto producto = new Producto();
        producto.setIdProd(id);
        producto.setNombre(nombre.trim());
        producto.setDescripcion(descripcion.trim());
        producto.setPrecio(precio);
        producto.setStock(stock);
        producto.setIdCategoria(idCategoria);

        if (id == 0) {
            // NUEVO PRODUCTO
            String nombreArchivo = procesarImagen(req);

            if (nombreArchivo != null) {
                producto.setImagen(nombreArchivo);
            }
                productoDAO.insertar(producto);
                req.getSession().setAttribute("success", "Producto creado correctamente.");
            } else {
             // PRODUCTO EXISTENTE
                Producto anterior = productoDAO.buscarPorId(id);

                String nombreArchivo = procesarImagen(req);

                if (nombreArchivo != null) {

                    // Se subió una imagen nueva
                    producto.setImagen(nombreArchivo);

                    // Eliminar la imagen antigua
                    eliminarImagen(anterior.getImagen());

                } else {
                // Mantener la imagen existente
                producto.setImagen(anterior.getImagen());
                }
                productoDAO.actualizar(producto);
                req.getSession().setAttribute("success", "Producto actualizado correctamente.");
            }

        resp.sendRedirect("AdminProductoControlador?accion=listar");
    }

    private String procesarImagen(HttpServletRequest req) throws IOException, ServletException {
        Part part = req.getPart("imagen");

        if (part == null || part.getSize() == 0) {
            return null;
        }

        String original = part.getSubmittedFileName();
        String extension = "";
        if (original != null && original.contains(".")) {
            extension = original.substring(original.lastIndexOf('.'));
        }

        String nombreUnico = UUID.randomUUID().toString() + extension;

        File carpeta = new File(CARPETA_IMAGENES);
        if (!carpeta.exists()) {
            carpeta.mkdirs();
        }

        Path destino = new File(carpeta, nombreUnico).toPath();
        try (var input = part.getInputStream()) {
            Files.copy(input, destino);
        }

        return nombreUnico;
    }

    private void redirigirConError(HttpServletRequest req, HttpServletResponse resp, int id, String mensaje)
            throws ServletException, IOException {
        req.getSession().setAttribute("error", mensaje);
        if (id > 0) {
            resp.sendRedirect("AdminProductoControlador?accion=editar&id=" + id);
        } else {
            resp.sendRedirect("AdminProductoControlador?accion=nuevo");
        }
    }

    private boolean esVacio(String s) {
        return s == null || s.trim().isEmpty();
    }

    private int parseIntSeguro(String valor, int porDefecto) {
        try {
            return Integer.parseInt(valor);
        } catch (Exception e) {
            return porDefecto;
        }
    }
    
    private void eliminarImagen(String nombreImagen) {
        if (nombreImagen != null && !nombreImagen.isEmpty()) {
            try{ 
                String rutaImagen = CARPETA_IMAGENES + nombreImagen;
                
                File archivoImagen = new File(rutaImagen); 
                
                if (archivoImagen.exists()) {
                    archivoImagen.delete(); 
                }
            }catch (Exception e) { 
                System.err.println("Error al eliminar imagen: " + e.getMessage()); 
            }
        }
    }
    
    
}

