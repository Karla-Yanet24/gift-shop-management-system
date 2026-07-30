
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html lang="es">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Panel Admin - Productos</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <style>
            .table-img {
                width: 60px;
                height: 60px;
                object-fit: cover;
                border-radius: 4px;
                border: 1px solid #dee2e6;
            }
            .action-buttons {
                min-width: 180px;
            }
            .stock-badge {
                font-size: 0.8em;
                padding: 4px 8px;
            }
            .card-shadow {
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            }
            .description-text {
                font-size: 0.875rem;
                color: #6c757d;
                line-height: 1.4;
            }
        </style>
    </head>
    <body class="admin-body">
        <jsp:include page="components/AdminSidebar.jsp">
            <jsp:param name="activo" value="productos" />
        </jsp:include>
        <jsp:include page="components/Mensaje.jsp" />

        <div class="admin-content">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2 class="mb-0">
                    <span class="me-2">🛒</span>
                    Administración de Productos
                </h2>
            </div>

            <!-- Alertas -->
            <c:if test="${not empty mensaje}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ✅ ${mensaje}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ❌ ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Botón Agregar y Contador -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="AdminProductoControlador?accion=nuevo" class="btn btn-success">
                    <i class="fa fa-plus"></i> Agregar Nuevo Producto
                </a>
                <span class="badge bg-fp-rosa-oscuro fs-6">
                    Total: ${listaProductos.size()} productos
                </span>
            </div>

            <!-- Tabla de Productos -->
            <div class="card card-shadow">
                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${empty listaProductos}">
                            <div class="text-center py-5">
                                <div class="text-muted mb-3">
                                    <h4>📦 No hay productos registrados</h4>
                                    <p>Comienza agregando tu primer producto al catálogo</p>
                                </div>
                                <a href="AdminProductoControlador?accion=nuevo" class="btn btn-primary btn-lg">
                                    <i class="fa-solid fa-plus"></i> Agregar Primer Producto
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bordered table-hover table-striped mb-0">
                                    <thead class="table-dark">
                                        <tr>
                                            <th width="80" class="text-center">ID</th>
                                            <th class="text-center">Producto</th>
                                            <th class="text-center">Categoría</th>
                                            <th width="120" class="text-center">Precio</th>
                                            <th width="100" class="text-center">Stock</th>
                                            <th width="100" class="text-center">Imagen</th>
                                            <th width="200" class="text-center">Acciones</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${listaProductos}">
                                            <tr>
                                                <td class="text-center fw-bold">${p.idProd}</td>
                                                <td>
                                                    <div class="fw-semibold text-dark mb-1">${p.nombre}</div>
                                                    <c:if test="${not empty p.descripcion}">
                                                        <div class="description-text">
                                                            ${p.descripcion}
                                                        </div>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="badge bg-fp-rosa text-center">
                                                        ${p.categoria}
                                                    </span>
                                                </td>
                                                <td class="text-center fw-bold text-success">
                                                    S/ ${p.precio}
                                                </td>
                                                <td class="text-center">
                                                    <span class="badge stock-badge ${p.stock > 10 ? 'bg-success' : p.stock > 0 ? 'bg-warning' : 'bg-danger'}">
                                                        <c:choose>
                                                            <c:when test="${p.stock > 5}">✅ ${p.stock}</c:when>
                                                            <c:when test="${p.stock > 0}">⚠️ ${p.stock}</c:when>
                                                            <c:otherwise>❌ Agotado</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <c:choose>
                                                        <c:when test="${not empty p.imagen && p.imagen != 'null'}">
                                                            <img src="${pageContext.request.contextPath}/assets/img/floreria/${p.imagen}" 
                                                                 class="table-img" 
                                                                 alt="${p.nombre}"
                                                                 onerror="this.onerror=null; this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iNjAiIHZpZXdCb3g9IjAgMCA2MCA2MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjYwIiBmaWxsPSIjRjNGNEY2Ii8+CjxwYXRoIGQ9Ik0zMCAzN0MzMy44NjYgMzcgMzcgMzMuODY2IDM3IDMwQzM3IDI2LjEzNCAzMy44NjYgMjMgMzAgMjNDMjYuMTM0IDIzIDIzIDI2LjEzNCAyMyAzMEMyMyAzMy44NjYgMjYuMTM0IDM3IDMwIDM3Wk0zMCA0MEMzNS41MjIgNDAgNDAgMzUuNTIyIDQwIDMwQzQwIDI0LjQ3OCAzNS41MjIgMjAgMzAgMjBDMjQuNDc4IDIwIDIwIDI0LjQ3OCAyMCAzMEMyMCAzNS41MjIgMjQuNDc4IDQwIDMwIDQwWk0xMi41IDQ3LjVINDcuNUM0OC4zMjg0IDQ3LjUgNDkgNDYuODI4NCA0OSA0NlYxNEM0OSAxMy4xNzE2IDQ4LjMyODQgMTIuNSA0Ny41IDEyLjVIMTIuNUMxMS42NzE2IDEyLjUgMTEgMTMuMTcxNiAxMSAxNFY0NkMxMSA0Ni44Mjg0IDExLjY3MTYgNDcuNSAxMi41IDQ3LjVaIiBmaWxsPSIjOUE5QTlBIi8+Cjwvc3ZnPgo=';">
                                                        </c:when>
                                                        <c:otherwise>
                                                            <div class="text-muted">
                                                                <small>📷 Sin imagen</small>
                                                            </div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="action-buttons">
                                                    <div class="d-flex gap-2 justify-content-center">
                                                        <a href="AdminProductoControlador?accion=editar&id=${p.idProd}" 
                                                           class="btn btn-warning btn-sm" 
                                                           title="Editar producto">
                                                            <i class="fa-solid fa-pen"></i> Editar
                                                        </a>
                                                        <a href="AdminProductoControlador?accion=eliminar&id=${p.idProd}" 
                                                           class="btn btn-danger btn-sm" 
                                                           onclick="return confirm('¿Estás seguro de eliminar el producto: ${p.nombre}?');"
                                                           title="Eliminar producto">
                                                            <i class="fa-solid fa-trash"></i> Eliminar
                                                        </a>
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
            // Auto-ocultar alertas después de 5 segundos
            document.addEventListener('DOMContentLoaded', function() {
                setTimeout(function() {
                    const alerts = document.querySelectorAll('.alert');
                    alerts.forEach(function(alert) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    });
                }, 5000);
            });
        </script>
    </body>
</html>
