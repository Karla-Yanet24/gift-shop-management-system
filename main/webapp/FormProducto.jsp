

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>${producto.idProd == 0 ? "Nuevo Producto" : "Editar Producto"}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
    <style>
        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border: 2px dashed #dee2e6;
            border-radius: 8px;
            padding: 10px;
            background: #f8f9fa;
        }
        .required-label::after {
            content: " *";
            color: #dc3545;
        }
        
    </style>
    <script>
        function previewImage(event) {
            const preview = document.getElementById('preview');
            const noImage = document.getElementById('no-image');
            const file = event.target.files[0];
            
            if (file) {
                // Validar tipo de archivo
                if (!file.type.match('image.*')) {
                    alert('❌ Por favor, selecciona solo archivos de imagen (JPG, PNG, GIF).');
                    event.target.value = '';
                    preview.style.display = 'none';
                    if (noImage) noImage.style.display = 'block';
                    return;
                }
                
                // Validar tamaño (max 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('❌ La imagen no debe superar los 5MB.');
                    event.target.value = '';
                    preview.style.display = 'none';
                    if (noImage) noImage.style.display = 'block';
                    return;
                }
                
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                    preview.style.borderColor = '#28a745';
                    if (noImage) noImage.style.display = 'none';
                };
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
                if (noImage) noImage.style.display = 'block';
            }
        }
        
        function validateForm() {
            const nombre = document.querySelector('input[name="nombre"]');
            const precio = document.querySelector('input[name="precio"]');
            const stock = document.querySelector('input[name="stock"]');
            const descripcion = document.querySelector('textarea[name="descripcion"]');
            const categoria = document.querySelector('select[name="categoria"]');
            
            // Validar nombre
            if (nombre.value.trim().length < 2) {
                alert('⚠️ El nombre debe tener al menos 2 caracteres.');
                nombre.focus();
                return false;
            }
            
            // Validar precio
            if (parseFloat(precio.value) <= 0) {
                alert('⚠️ El precio debe ser mayor a 0.');
                precio.focus();
                return false;
            }
            
            // Validar stock
            if (parseInt(stock.value) < 0) {
                alert('⚠️ El stock no puede ser negativo.');
                stock.focus();
                return false;
            }
            
            // Validar descripción
            if (descripcion.value.trim().length < 10) {
                alert('⚠️ La descripción debe tener al menos 10 caracteres.');
                descripcion.focus();
                return false;
            }
            
            //Validar categoría
            if (categoria.value === "") {
                alert('⚠️ Por favor, selecciona una categoría válida.');
                categoria.focus();
                return false;
            }
            
            return true;
        }
        
        // Mostrar imagen actual al cargar la página
        document.addEventListener('DOMContentLoaded', function() {
            const currentImage = '${producto.imagen}';
            const preview = document.getElementById('preview');
            const noImage = document.getElementById('no-image');
            
            if (currentImage && currentImage !== '' && currentImage !== 'null') {
                preview.src = '${pageContext.request.contextPath}/assets/img/floreria/' + currentImage;
                preview.style.display = 'block';
                if (noImage) noImage.style.display = 'none';
            } else {
                preview.style.display = 'none';
                if (noImage) noImage.style.display = 'block';
            }
        });
    </script>
</head>
<body class="admin-body">
    <jsp:include page="components/AdminSidebar.jsp">
        <jsp:param name="activo" value="productos" />
    </jsp:include>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <jsp:include page="components/Mensaje.jsp" />
    <div class="admin-content">
        <div class="row justify-content-center">
            <div class="col-md-10 col-lg-8">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4 class="card-header form-label">
                        <c:choose>
                            <c:when test="${producto.idProd == 0}"> 
                                <i class="fa fa-plus"></i> Agregar Nuevo Producto
                            </c:when>
                            <c:otherwise> 
                                <i class="fa fa-edit"></i> Editar Producto
                            </c:otherwise>
                        </c:choose>
                    </h3>
                    <a href="AdminProductoControlador?accion=listar" class="btn btn-outline-secondary">
                        📋 Volver a la Lista
                    </a>
                </div>

                <!-- Formulario -->
                <div class="card shadow">
                    <div class="card-header bg-fp-rosa form-label">
                        <h5 class="mb-0">
                            <c:choose>
                                <c:when test="${producto.idProd == 0}">Información del Nuevo Producto</c:when>
                                <c:otherwise>Editando: ${producto.nombre}</c:otherwise>
                            </c:choose>
                        </h5>
                    </div>
                    
                    <form action="AdminProductoControlador" method="post" 
                          enctype="multipart/form-data" class="card-body" onsubmit="return validateForm()">
                        <input type="hidden" name="id" value="${producto.idProd}" />
                        
                        <div class="row">
                            <!-- Columna Izquierda - Datos del Producto -->
                            <div class="col-md-8">
                                <div class="mb-3">
                                    <label class="form-label fw-bold required-label">Nombre del Producto:</label>
                                    <input type="text" name="nombre" value="${producto.nombre}" 
                                           class="form-control" 
                                           placeholder="Ingrese el nombre del producto" 
                                           required 
                                           maxlength="100" />
                                    <div class="form-text">Mínimo 2 caracteres, máximo 100.</div>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label fw-bold required-label">Descripción:</label>
                                    <textarea name="descripcion" class="form-control" rows="4" 
                                              placeholder="Describa las características, beneficios y detalles del producto..." 
                                              required 
                                              maxlength="500">${producto.descripcion}</textarea>
                                    <div class="form-text">Mínimo 10 caracteres, máximo 500.</div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Categoría:</label>
                                    <select name="categoria" class="form-select" required>
                                        <option value="" disabled ${producto.idProd == 0 ? 'selected' : ''}>-- Seleccione una categoría --</option>
                                        <c:forEach items="${listaCategorias}" var="cat">
                                            <option value="${cat.idCategoria}" ${producto.idCategoria == cat.idCategoria ? 'selected' : ''}>${cat.nombre}</option>
                                        </c:forEach>
                                    </select>
                                    <div class="form-text">Selecciona la categoría correspondiente de la lista.</div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold required-label">Precio (S/):</label>
                                            <div class="input-group">
                                                <span class="input-group-text">S/</span>
                                                <input type="number" step="0.01" min="0.01" name="precio" 
                                                       value="${producto.precio}" 
                                                       class="form-control" 
                                                       placeholder="0.00" 
                                                       required />
                                            </div>
                                            <div class="form-text">Precio en soles.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label class="form-label fw-bold required-label">Stock:</label>
                                            <input type="number" name="stock" min="0" value="${producto.stock}" 
                                                   class="form-control" 
                                                   placeholder="0" 
                                                   required />
                                            <div class="form-text">Cantidad disponible.</div>
                                        </div>
                                    </div>
                                </div>
                                
                                
                                
                            </div>
                            
                            <!-- Columna Derecha - Imagen -->
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label fw-bold">Imagen del Producto:</label>
                                    <input type="file" name="imagen" accept="image/*" 
                                           class="form-control" 
                                           onchange="previewImage(event)" />
                                    <div class="form-text">
                                        Formatos: JPG, PNG, GIF. Máx: 5MB
                                        <c:if test="${producto.idProd != 0 && not empty producto.imagen}">
                                            <br><span class="text-info">⚠️ Dejar vacío para mantener la imagen actual.</span>
                                        </c:if>
                                    </div>
                                    
                                    <!-- Vista previa de imagen -->
                                    <div class="mt-3 text-center">
                                        <img id="preview" 
                                             class="image-preview" 
                                             style="display: none;"
                                             alt="Vista previa">
                                        <div id="no-image" class="text-muted mt-2">
                                            <small>📷 No hay imagen seleccionada</small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Botones de acción -->
                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                            <div>
                                <small class="text-muted">Los campos marcados con * son obligatorios</small>
                            </div>
                            <div class="d-flex gap-2">
                                <a href="AdminProductoControlador?accion=listar" class="btn btn-outline-secondary">
                                    ❌ Cancelar
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <c:choose>
                                        <c:when test="${producto.idProd == 0}">💾 Crear Producto</c:when>
                                        <c:otherwise>💾 Actualizar Producto</c:otherwise>
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
