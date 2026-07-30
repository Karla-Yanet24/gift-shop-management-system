<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="es">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Categorías</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <style>
            .card-shadow {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }
            .descripcion-text {
                font-size: 0.875rem;
                color: #6c757d;
            }
        </style>
    </head>
    <body class="admin-body">
        <jsp:include page="components/AdminSidebar.jsp">
            <jsp:param name="activo" value="categorias" />
        </jsp:include>
        <jsp:include page="components/Mensaje.jsp" />

        <div class="admin-content">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <i class="fa fa-tags me-2"></i> Administración de Categorías
                </h2>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="AdminCategoriaControlador?accion=nuevo" class="btn btn-success">
                    <i class="fa fa-plus"></i> Nueva Categoría
                </a>
                <span class="badge bg-fp-rosa-oscuro fs-6">
                    Total: ${listaCategorias.size()} categorías
                </span>
            </div>

            <div class="card card-shadow">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty listaCategorias}">
                            <div class="text-center py-5">
                                <i class="fa fa-tags fa-3x text-muted mb-3"></i>
                                <h4 class="text-muted">No hay categorías registradas</h4>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-striped mb-0 align-middle">
                                    <thead class="table-dark">
                                        <tr>
                                            <th class="text-center" width="60">ID</th>
                                            <th class="text-center">Nombre</th>
                                            <th class="text-center">Descripción</th>
                                            <th class="text-center" width="120">Productos</th>
                                            <th class="text-center" width="100">Estado</th>
                                            <th class="text-center" width="220">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="cat" items="${listaCategorias}">
                                            <tr class="${cat.estado ? '' : 'table-secondary'}">
                                                <td class="text-center fw-bold">${cat.idCategoria}</td>
                                                <td class="fw-semibold">${cat.nombre}</td>
                                                <td class="descripcion-text">${cat.descripcion}</td>
                                                <td class="text-center">
                                                    <span class="badge bg-fp-rosa text-dark">${conteoProductos[cat.idCategoria]}</span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${cat.estado}">
                                                            <span class="badge bg-success">Activa</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Inactiva</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex gap-2 justify-content-center">
                                                        <a href="AdminCategoriaControlador?accion=editar&id=${cat.idCategoria}"
                                                           class="btn btn-warning btn-sm" title="Editar">
                                                            <i class="fa fa-edit"></i> Editar
                                                        </a>
                                                        <c:choose>
                                                            <c:when test="${cat.estado}">
                                                                <a href="AdminCategoriaControlador?accion=desactivar&id=${cat.idCategoria}"
                                                                   class="btn btn-outline-danger btn-sm" title="Ocultar"
                                                                   onclick="return confirm('¿Ocultar la categoría ${cat.nombre}? No se mostrará en el catálogo público.');">
                                                                    <i class="fa fa-eye-slash"></i> Ocultar
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a href="AdminCategoriaControlador?accion=activar&id=${cat.idCategoria}"
                                                                   class="btn btn-outline-success btn-sm" title="Visualizar">
                                                                    <i class="fa fa-eye"></i> Visualizar
                                                                </a>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(function () {
                    document.querySelectorAll('.alert').forEach(function (alert) {
                        new bootstrap.Alert(alert).close();
                    });
                }, 5000);
            });
        </script>
    </body>
</html>
