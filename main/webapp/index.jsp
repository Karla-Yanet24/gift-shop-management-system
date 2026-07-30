<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Florería Primavera</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css" integrity="sha512-2SwdPD6INVrV/lHTZbO2nodKhrnDdJK9/kg2XD1r9uGqPo1cUbujc+IYdlYdEErWNu69gVcYgdxlmVmzTWnetw==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <link href="assets/css/estilos.css" rel="stylesheet" type="text/css"/>
        <style>
            /* --- Carrusel de categoría: fila con scroll horizontal suave --- */
            .categoria-bloque {
                margin-bottom: 2.5rem;
            }
            .categoria-titulo {
                font-weight: 700;
                color: var(--fp-verde-oscuro);
                border-left: 5px solid var(--fp-rosa);
                padding-left: .6rem;
                margin-bottom: .9rem;
            }
            .carrusel-wrapper {
                position: relative;
            }
            .carrusel-track {
                display: flex;
                gap: 1rem;
                overflow-x: auto;
                scroll-behavior: smooth;
                padding: .25rem .25rem 1rem .25rem;
                scrollbar-width: none;            /* Firefox: oculta la barra de scroll nativa */
            }
            .carrusel-track::-webkit-scrollbar {  /* Chrome/Edge: oculta la barra de scroll nativa */
                display: none;
            }
            .carrusel-item {
                flex: 0 0 auto;
                width: 230px;
            }
            .carrusel-flecha {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                z-index: 5;
                width: 38px;
                height: 38px;
                border-radius: 50%;
                border: none;
                background: var(--fp-verde-oscuro);
                color: #fff;
                opacity: .92;
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 2px 6px rgba(0,0,0,.25);
            }
            .carrusel-flecha i{
                font-size: 1rem;
                font-weight: 700;
                line-height: 1;
            }
            .carrusel-flecha:hover {
                opacity: 1;
                background: var(--fp-rosa-oscuro);
            }
            .carrusel-flecha.izq { left: -6px; }
            .carrusel-flecha.der { right: -6px; }

            @media (max-width: 576px) {
                .carrusel-item { width: 190px; }
            }
        </style>
    </head>
    <body>

        <!-- Menú de navegación -->
        <jsp:include page="components/Navegacion.jsp" />

        <!-- Contenedor de productos agrupados por categoría -->
        <div class="container py-4">

            <c:choose>
                <c:when test="${not empty categorias}">

                    <%--
                        ${categorias} es un Map<idCategoria, List<Producto>> ya agrupado
                        por InicioControlador (LinkedHashMap, conserva el orden). Cada
                        entrada del mapa es exactamente un carrusel: nada de comparar
                        "categoría anterior" dentro del JSP.
                    --%>
                    <c:forEach items="${categorias}" var="grupo">
                        <c:set var="listaGrupo" value="${grupo.value}" />
                        <c:set var="primerProducto" value="${listaGrupo[0]}" />

                        <div class="categoria-bloque">
                            <h4 class="categoria-titulo">${primerProducto.categoria}</h4>

                            <div class="carrusel-wrapper">
                                <button type="button" class="carrusel-flecha izq"
                                        onclick="moverCarrusel('cat-${grupo.key}', -1)">
                                    <i class="fa fa-chevron-left"></i>
                                </button>

                                <div class="carrusel-track" id="cat-${grupo.key}">
                                    <c:forEach items="${listaGrupo}" var="item">
                                        <div class="carrusel-item">
                                            <form action="CarritoControlador" method="get">
                                                <div class="card h-100 shadow-sm border-0 rounded-3">
                                                    <img src="assets/img/floreria/${item.imagen}"
                                                         class="card-img-top p-3"
                                                         alt="${item.nombre}"
                                                         style="height:180px; object-fit:contain;">

                                                    <div class="card-body d-flex flex-column">
                                                        <h6 class="fw-bold text-dark">${item.nombre}</h6>
                                                        <p class="text-warning small mb-1">Personaliza el tuyo</p>
                                                        <span class="badge bg-success mb-2">Entrega el mismo día</span>

                                                        <input type="hidden" name="accion" value="agregar">
                                                        <input type="hidden" name="id" value="${item.idProd}">

                                                        <div class="mt-auto d-flex justify-content-between align-items-center">
                                                            <small class="fw-bold text-primary fs-6">S/ ${item.precio}</small>
                                                            <button type="submit" class="btn btn-sm btn-outline-primary">
                                                                <i class="fa fa-cart-plus"></i> Agregar
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </c:forEach>
                                </div>

                                <button type="button" class="carrusel-flecha der"
                                        onclick="moverCarrusel('cat-${grupo.key}', 1)">
                                    <i class="fa fa-chevron-right"></i>
                                </button>
                            </div>
                        </div>
                    </c:forEach>

                </c:when>
                <c:otherwise>
                    <div class="col-12 text-center mt-5">
                        <i class="fa fa-info-circle fa-3x text-muted"></i>
                        <p class="mt-3">Lo sentimos, no hay productos disponibles en este momento.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Scripts Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js" integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

        <script>
            // Mueve el carrusel de la categoría indicada un "paso" (aprox. 70% del ancho visible).
            function moverCarrusel(idTrack, direccion) {
                var track = document.getElementById(idTrack);
                if (!track) return;
                var paso = track.clientWidth * 0.7;
                track.scrollBy({ left: direccion * paso, behavior: 'smooth' });
            }
        </script>
    </body>
</html>
