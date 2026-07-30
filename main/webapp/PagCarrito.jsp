
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Carrito</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" 
              rel="stylesheet" 
              integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" 
              crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" 
              integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" 
              crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <style>
            #bloqueComprobante { display: none; }
            .resumen-tabla td { padding: 3px 6px; font-size: 0.92rem; }
            .badge-cupon { font-size: 0.78rem; }
        </style>

    </head>
    <body>
        <!-- Menú de navegación -->
        <jsp:include page="components/Navegacion.jsp" />
        <jsp:include page="components/Mensaje.jsp"/>

        <!-- Contenedor de carrito -->
        <div class="container py-4">
            <h4>🌷 Pedido </h4>
            <hr>
            <form action="PedidoControlador" method="post" enctype="multipart/form-data">
                <div class="row">
                    <!-- Tabla de productos -->
                    <div class="${empty carrito || carrito.size() == 0 ? 'col-sm-12' : 'col-sm-9'}">
                    <div class="card">
                        <div class="card-body">
                            <table class="table table-bordered table-striped align-middle">
                                <thead class="text-white">
                                    <tr>
                                        <th>Imagen</th>
                                        <th>Producto</th>
                                        <th>Precio (S/)</th>
                                        <th>Cantidad</th>
                                        <th>Importe (S/)</th>
                                        <th>Acción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${carrito}" var="item" varStatus="loop">
                                        <tr>
                                            <td class="text-center">
                                                <img src="assets/img/floreria/${item.producto.imagen}" 
                                                     width="100" height="90" 
                                                     alt="${item.producto.nombre}"/>
                                            </td>
                                            <td>${item.producto.nombre}
                                                <%-- Campo de dedicatoria: visible solo si la categoría lo permite --%>
                                                <c:if test="${sessionScope.permiteDedicatoria[item.producto.idCategoria]}">
                                                    <div class="mt-2">
                                                        <input type="text"
                                                               name="dedicatoria_${loop.index}"
                                                               class="form-control form-control-sm"
                                                               maxlength="150"
                                                               placeholder="✉️ Dedicatoria (opcional)"
                                                               value="${item.dedicatoria}">
                                                    </div>
                                                </c:if>                                            
                                            </td>
                                            <td
                                                class="precio-unitario"
                                                data-precio="${item.producto.precio}"
                                                data-cantidad="${item.cantidad}">
                                                S/ ${item.producto.precio}
                                            </td>
                                            <td class="text-center" style="min-width: 130px;">
                                                <div class="btn-group" role="group">
                                                    <a href="CarritoControlador?accion=disminuir&indice=${loop.index}"
                                                       title="Disminuir" class="btn btn-outline-secondary btn-sm">
                                                        <i class="fa fa-minus"></i>
                                                    </a>
                                                    <span class="btn btn-light btn-sm disabled">${item.cantidad}</span>
                                                    <a href="CarritoControlador?accion=aumentar&indice=${loop.index}"
                                                       title="Aumentar" class="btn btn-outline-secondary btn-sm">
                                                        <i class="fa fa-plus"></i>
                                                    </a>
                                                </div>
                                            </td>                                            
                                            <td>S/ ${item.producto.precio * item.cantidad}</td>
                                            <td class="text-center">
                                                <a href="CarritoControlador?accion=eliminar&indice=${loop.index}" 
                                                   title="Eliminar" class="btn btn-danger btn-sm">
                                                    <i class="fa fa-trash-alt"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <!-- Si el carrito está vacío -->
                                    <c:if test="${carrito == null || carrito.size() == 0}">
                                        <tr class="text-center">
                                            <td colspan="6">🛒 Carrito vacío!</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Resumen compra -->
                <c:if test="${not empty carrito && carrito.size() > 0}">
                <div class="col-sm-3">
                    <div class="card">
                        <div class="card-body">
                            <h5>RESUMEN DE COMPRA</h5>
                            <hr/>

                            <!-- ── DIRECCIÓN DE ENTREGA ── -->
                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    Distrito: <span class="text-danger">*</span>
                                </label>
                                <select id="distritoDelivery" name="distritoDelivery"
                                        class="form-select form-select-sm"
                                        onchange="calcularResumen()" required>
                                    <option value="">-- Selecciona tu distrito --</option>
                                    <optgroup label="Zona Básica (S/ 5)">
                                        <option value="Villa El Salvador">Villa El Salvador</option>
                                        <option value="Villa María del Triunfo">Villa María del Triunfo</option>
                                        <option value="Lurín">Lurín</option>
                                        <option value="Pachacámac">Pachacámac</option>
                                        <option value="Miraflores">Miraflores</option>
                                        <option value="San Isidro">San Isidro</option>
                                        <option value="San Borja">San Borja</option>
                                        <option value="Surco">Surco (Santiago de Surco)</option>
                                        <option value="La Molina">La Molina</option>
                                    </optgroup>
                                    <optgroup label="Zona Estándar (S/ 10)">
                                        <option value="Lince">Lince</option>
                                        <option value="Jesús María">Jesús María</option>
                                        <option value="Magdalena del Mar">Magdalena del Mar</option>
                                        <option value="San Miguel">San Miguel</option>
                                        <option value="Pueblo Libre">Pueblo Libre</option>
                                        <option value="Barranco">Barranco</option>
                                        <option value="Chorrillos">Chorrillos</option>
                                        <option value="Surquillo">Surquillo</option>
                                    </optgroup>
                                    <optgroup label="Zona Extendida (S/ 15)">
                                        <option value="Ate">Ate</option>
                                        <option value="La Victoria">La Victoria</option>
                                        <option value="El Agustino">El Agustino</option>
                                        <option value="Santa Anita">Santa Anita</option>
                                        <option value="San Luis">San Luis</option>
                                        <option value="Cercado de Lima">Cercado de Lima</option>
                                        <option value="Breña">Breña</option>
                                        <option value="Rímac">Rímac</option>
                                        <option value="San Martín de Porres">San Martín de Porres</option>
                                        <option value="Los Olivos">Los Olivos</option>
                                        <option value="San Juan de Lurigancho">San Juan de Lurigancho</option>
                                        <option value="Independencia">Independencia</option>
                                        <option value="Comas">Comas</option>
                                        <option value="Puente Piedra">Puente Piedra</option>
                                        <option value="Carabayllo">Carabayllo</option>
                                        <option value="Ancón">Ancón</option>
                                        <option value="Santa Rosa">Santa Rosa</option>
                                        <option value="Chaclacayo">Chaclacayo</option>
                                        <option value="Cieneguilla">Cieneguilla</option>
                                    </optgroup>
                                    <optgroup label="Zona Gratuita (S/ 0)">
                                        <option value="Punta Hermosa">Punta Hermosa</option>
                                        <option value="Punta Negra">Punta Negra</option>
                                        <option value="San Bartolo">San Bartolo</option>
                                        <option value="Santa María del Mar">Santa María del Mar</option>
                                        <option value="Pucusana">Pucusana</option>
                                    </optgroup>
                                </select>
                            </div>

                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    Calle / Dirección: <span class="text-danger">*</span>
                                </label>
                                <input type="text" id="direccionCalle" name="direccionCalle"
                                       class="form-control form-control-sm"
                                       placeholder="Av. Ejemplo 123, Dpto. 4B"
                                       required>
                            </div>

                            <hr class="my-2"/>

                            <!-- ── PERSONALIZACIÓN DEL PEDIDO ── -->
                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    <i class="fa fa-calendar-alt"></i> Fecha y hora de entrega:
                                </label>
                                <input type="datetime-local" id="fechaEntrega" name="fechaEntrega"
                                       class="form-control form-control-sm">
                            </div>

                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    <i class="fa fa-seedling"></i> Colores de la flor:
                                </label>
                                <input type="text" id="personalizacion" name="personalizacion"
                                       class="form-control form-control-sm"
                                       placeholder="Ej: Rosas rojas, girasoles amarillos..."
                                       maxlength="200">
                            </div>

                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    <i class="fa fa-comment-dots"></i> Observaciones adicionales:
                                </label>
                                <textarea id="observaciones_usuario" name="observaciones_usuario"
                                          class="form-control form-control-sm" rows="2"
                                          placeholder="Indicaciones, referencias, etc."
                                          maxlength="300"></textarea>
                            </div>

                            <hr class="my-2"/>

                            <!-- ── MÉTODO DE PAGO ── -->
                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">Método de pago:</label>
                                <select id="metodoPago" name="metodoPago" class="form-select form-select-sm"
                                        onchange="toggleComprobante(this.value)">
                                    <option value="Yape">Yape</option>
                                    <option value="Plin">Plin</option>
                                    <option value="Tarjeta">Tarjeta</option>
                                    <option value="Efectivo" selected>Efectivo</option>
                                </select>
                            </div>

                            <!-- Bloque de comprobante: solo visible cuando el pago es Yape o Plin -->
                            <div class="mb-2 text-start" id="bloqueComprobante">
                                <label class="form-label fw-bold text-primary">
                                    <i class="fa fa-image"></i> Comprobante de pago:
                                </label>
                                <input type="file" name="comprobante" id="comprobante"
                                       class="form-control form-control-sm" accept="image/*"
                                       onchange="previsualizarComprobante(this)">
                                <div class="form-text">Sube la captura de tu Yape o Plin (JPG, PNG)</div>
                                <div class="mt-2" id="contenedorPrevistaComprobante"></div>
                            </div>

                            <hr class="my-2"/>

                            <!-- ── CUPÓN DE DESCUENTO ── -->
                            <div class="mb-2 text-start">
                                <label class="form-label fw-semibold">
                                    <i class="fa fa-tag"></i> Cupón de descuento:
                                </label>
                                <div class="input-group input-group-sm">
                                    <input type="text" id="cupon" name="cupon"
                                           class="form-control text-uppercase"
                                           placeholder="Código de cupón"
                                           maxlength="20"
                                           oninput="this.value = this.value.toUpperCase()">
                                    <button type="button" class="btn btn-outline-secondary"
                                            onclick="aplicarCupon()">
                                        Aplicar
                                    </button>
                                </div>
                                <div id="mensajeCupon" class="small mt-1"></div>
                            </div>

                            <hr class="my-2"/>

                            <!-- ── RESUMEN DINÁMICO ── -->
                            <table class="table table-sm resumen-tabla mb-2">
                                <tbody>
                                    <tr>
                                        <td>Subtotal productos:</td>
                                        <td class="text-end fw-semibold" id="resSubtotal">S/ 0.00</td>
                                    </tr>
                                    <tr>
                                        <td>Costo de delivery:</td>
                                        <td class="text-end fw-semibold" id="resDelivery">S/ 0.00</td>
                                    </tr>
                                    <tr class="text-success">
                                        <td>Descuento cupón:</td>
                                        <td class="text-end fw-semibold" id="resDescuento">- S/ 0.00</td>
                                    </tr>
                                    <tr class="fw-bold fs-6">
                                        <td>TOTAL:</td>
                                        <td class="text-end text-primary" id="resTotal">S/ 0.00</td>
                                    </tr>
                                </tbody>
                            </table>

                            <!-- Campos ocultos que el servidor necesita -->
                            <input type="hidden" id="totalFinal"     name="totalFinal"     value="0">
                            <input type="hidden" id="costoDelivery"  name="costoDelivery"  value="0">
                            <input type="hidden" id="descuentoCupon" name="descuentoCupon" value="0">
                            <input type="hidden" name="accion" value="procesar">

                            <button ${carrito.size()== 0 ? 'disabled': ''} type="submit"
                                    class="btn btn-warning w-100 btn-lg">
                                <i class="fa fa-credit-card"></i> Procesar compra
                            </button>
                        </div>
                    </div>
                </div>
                </div>
            </c:if>
        </form>
    </div>

        <!-- Scripts Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" 
                integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" 
        crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js" 
                integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y" 
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        
        <script>
            // ────────────────────────────────────────────────────────
            // MAPA DE DELIVERY POR DISTRITO
            // ────────────────────────────────────────────────────────
            const DELIVERY = {
                
                // Zona Básica (S/ 5)
                "Miraflores": 5, "San Isidro": 5, "San Borja": 5,
                "Surco": 5, "La Molina": 5, "Villa El Salvador": 5,
                "Villa María del Triunfo": 5, "Lurín": 5, "Pachacámac": 5,
                // Zona Estándar (S/ 10)
                "Lince": 10, "Jesús María": 10, "Magdalena del Mar": 10,
                "San Miguel": 10, "Pueblo Libre": 10, "Barranco": 10,
                "Chorrillos": 10, "Surquillo": 10,
                // Zona Extendida (S/ 15)
                "Ate": 15, "La Victoria": 15, "El Agustino": 15,
                "Santa Anita": 15, "San Luis": 15, "Cercado de Lima": 15,
                "Breña": 15, "Rímac": 15, "San Martín de Porres": 15,
                "Los Olivos": 15, "Independencia": 15, "Comas": 15,
                "San Juan de Lurigancho": 15, "Puente Piedra": 15, 
                "Carabayllo": 15, "Ancón": 15,"Santa Rosa": 15,
                "Chaclacayo": 15, "Cieneguilla": 15,
                // Zona Gratuita
                "Punta Hermosa": 0, "Punta Negra": 0, "San Bartolo": 0,
                "Santa María del Mar": 0, "Pucusana": 0
            };

            // ── Calcular subtotal desde los precios en la tabla ──
            function calcularSubtotal() {
                let subtotal = 0;
                document.querySelectorAll('.precio-unitario').forEach(function(td) {
                    const precio   = parseFloat(td.dataset.precio)   || 0;
                    const cantidad = parseInt(td.dataset.cantidad, 10) || 0;
                    subtotal += precio * cantidad;
                });
                return subtotal;
            }

            // Bandera: cupón aplicado
            let cuponAplicado = false;

            // ── Actualizar el resumen completo ──
            function calcularResumen() {
                const distrito  = document.getElementById('distritoDelivery').value;
                const delivery  = DELIVERY[distrito] !== undefined ? DELIVERY[distrito] : 0;
                const subtotal  = calcularSubtotal();
                const descuento = cuponAplicado ? subtotal * 0.10 : 0;
                const total     = subtotal + delivery - descuento;

                document.getElementById('resSubtotal').textContent  = 'S/ ' + subtotal.toFixed(2);
                document.getElementById('resDelivery').textContent  = 'S/ ' + delivery.toFixed(2);
                document.getElementById('resDescuento').textContent = '- S/ ' + descuento.toFixed(2);
                document.getElementById('resTotal').textContent     = 'S/ ' + total.toFixed(2);

                // Actualizar campos ocultos para el servidor
                document.getElementById('totalFinal').value     = total.toFixed(2);
                document.getElementById('costoDelivery').value  = delivery.toFixed(2);
                document.getElementById('descuentoCupon').value = descuento.toFixed(2);
            }

            // ── Validar y aplicar cupón ──
            function aplicarCupon() {
                const codigo  = document.getElementById('cupon').value.trim().toUpperCase();
                const msgDiv  = document.getElementById('mensajeCupon');

                if (codigo === 'PRIMAVERA10') {
                    cuponAplicado = true;
                    msgDiv.innerHTML = '<span class="text-success"><i class="fa fa-check-circle"></i> '
                        + '¡Cupón aplicado! 10% de descuento sobre productos.</span>';
                } else if (codigo === '') {
                    cuponAplicado = false;
                    msgDiv.innerHTML = '<span class="text-muted">Ingresa un código de cupón.</span>';
                } else {
                    cuponAplicado = false;
                    msgDiv.innerHTML = '<span class="text-danger"><i class="fa fa-times-circle"></i> '
                        + 'Cupón inválido.</span>';
                }
                calcularResumen();
            }

            // ── Mostrar/ocultar bloque comprobante ──
            function toggleComprobante(metodo) {
                var bloque    = document.getElementById('bloqueComprobante');
                var inputFile = document.getElementById('comprobante');
                if (metodo === 'Yape' || metodo === 'Plin') {
                    bloque.style.display = 'block';
                } else {
                    bloque.style.display = 'none';
                    inputFile.value = '';
                    document.getElementById('contenedorPrevistaComprobante').innerHTML = '';
                }
            }

            // ── Miniatura previa del comprobante ──
            function previsualizarComprobante(input) {
                var contenedor = document.getElementById('contenedorPrevistaComprobante');
                contenedor.innerHTML = '';
                if (input.files && input.files[0]) {
                    var reader = new FileReader();
                    reader.onload = function(e) {
                        contenedor.innerHTML =
                            '<img src="' + e.target.result + '" ' +
                            'class="img-thumbnail mt-1" style="max-width:100%; max-height:160px;" ' +
                            'alt="Vista previa del comprobante">';
                    };
                    reader.readAsDataURL(input.files[0]);
                }
            }

            // ── Calcular al cargar la página ──
            window.addEventListener('DOMContentLoaded', calcularResumen);
        </script>
        
    </body>
</html>
