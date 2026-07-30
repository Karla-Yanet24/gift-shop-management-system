
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registrarse</title>
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
    </head>
    <body>
        <!-- Menú de navegación -->
        <jsp:include page="components/Navegacion.jsp" />
        <jsp:include page="components/Mensaje.jsp"/>


        <!-- Contenedor de carrito -->
        <div class="container py-4">

            <div class="row">
                <div class="col-sm-12">
                    <div class="card form-registro" >
                        <h3>Registar cliente</h3>
                        <hr>
                        <div class="card-body">
                            <form action="ClienteControlador" method="post">
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="mb-3">
                                            <label>Nombres: <span class="obligatorio">(*)</span></label>
                                            <input value="${cliente.nombres}" type="text" class="form-control" required=""
                                                   name="nombres" placeholder="Ingrese su nombre"/>                                               
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="mb-3">
                                            <label>Apellidos: <span class="obligatorio">(*)</span></label>
                                            <input value="${cliente.apellidos}"type="text" class="form-control" required=""
                                                   name="apellidos" placeholder="Ingrese sus apellido"/>                                               
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="mb-3">
                                            <label>Telefono: </label>
                                            <input value="${cliente.telefono}"type="tel" class="form-control" 
                                                   name="telefono" placeholder="Ingrese su telefono"/>                                               
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="mb-3">
                                            <label>Correo Electronico: <span class="obligatorio">(*)</span></label>
                                            <input value="${cliente.correo}"type="email" class="form-control" 
                                                   name="correo" placeholder="Ingrese su correo electronico" required=""/>                                               
                                        </div>
                                    </div>

                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="mb-3">
                                            <label>Contraseña: <span class="obligatorio">(*)</span></label>
                                            <input value="${cliente.password}" type="password" class="form-control" 
                                                   name="contrasena" placeholder="Ingrese su contraseña" required=""/>                                               
                                        </div>
                                    </div>

                                </div>                   
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="mb-3">
                                            <label>Distrito: <span class="obligatorio">(*)</span></label>
                                            <input value="${cliente.distrito}" type="text" class="form-control" 
                                                   name="distrito" placeholder="Ingrese distrito" required=""/>                                               
                                        </div>
                                    </div>

                                </div>                   
                                
                                
                                <input type="hidden" name="accion" value="guardar"/>

                                <button type="submit" class="btn btn-primary">Registrarse</button>

                            </form>

                        </div>

                    </div>

                </div>


            </div>
        </div>

        <!-- Scripts Bootstrap -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" 
                integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" 
        crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js" 
                integrity="sha384-G/EV+4j2dNv+tEPo3++6LCgdCROaejBqfUeNjuKAiuXbjrxilcCdDz6ZAVfHWe1Y" 
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    </body>
</html>
