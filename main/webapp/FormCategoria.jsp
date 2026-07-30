
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${categoria.idCategoria == 0 ? "Nueva Categoría" : "Editar Categoría"}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>    
    <style>
        .required-label::after {
            content: " *";
            color: #dc3545;
        }
    </style>
</head>
<body class="admin-body">
    <jsp:include page="components/AdminSidebar.jsp">
        <jsp:param name="activo" value="categorias" />
    </jsp:include>
    <jsp:include page="components/Mensaje.jsp" />

    <div class="admin-content">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm">
                    <div class="card-header bg-fp-rosa">
                        <h4 class="mb-0">
                            <c:choose>
                                <c:when test="${categoria.idCategoria == 0}">
                                    <i class="fa fa-plus"></i> Nueva Categoría
                                </c:when>
                                <c:otherwise>
                                    <i class="fa fa-edit"></i> Editar Categoría
                                </c:otherwise>
                            </c:choose>
                        </h4>
                    </div>
                    <form action="AdminCategoriaControlador" method="post" class="card-body">
                        <input type="hidden" name="accion" value="guardar">
                        <input type="hidden" name="id" value="${categoria.idCategoria}">

                        <div class="mb-3">
                            <label class="form-label required-label">Nombre de la categoría:</label>
                            <input type="text" name="nombre" class="form-control"
                                   value="${categoria.nombre}" placeholder="Ej: Ramos, Arreglos, Peluches"
                                   minlength="2" maxlength="80" required="*">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Descripción:</label>
                            <textarea name="descripcion" class="form-control" rows="3"
                                      placeholder="Breve descripción de la categoría (opcional)">${categoria.descripcion}</textarea>
                        </div>
                        
                        <div class="mb-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" role="switch"
                                       name="permiteDedicatoria" id="permiteDedicatoria"
                                       ${categoria.permiteDedicatoria ? 'checked' : ''}>
                                <label class="form-check-label" for="permiteDedicatoria">
                                    <strong>Permite dedicatoria</strong>
                                    <span class="text-muted small d-block">
                                        Si está activo, el cliente podrá escribir un mensaje personalizado para cada producto de esta categoría al hacer su pedido.
                                    </span>
                                </label>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                            <small class="text-muted">Los campos marcados con * son obligatorios</small>
                            <div class="d-flex gap-2">
                                <a href="AdminCategoriaControlador?accion=listar" class="btn btn-outline-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <c:choose>
                                        <c:when test="${categoria.idCategoria == 0}">💾 Crear Categoría</c:when>
                                        <c:otherwise> 💾 Actualizar Categoría</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
