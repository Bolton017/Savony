<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.ResourceBundle"%>
<%@page import="java.util.Locale"%>
<%@page import="javax.ejb.ConcurrentAccessTimeoutException"%>
<%@page import="bean.CGenUtil"%>
<%@page import="mg.cnaps.messagecommunication.Message"%>
<%@page import="historique.MapUtilisateur"%>

<%@page import="user.UserEJB"%>
<%@ page import="bean.Constante" %>
<%
    HttpSession sess = request.getSession();
    String lang = "fr";
%>
<%
    String lien = (String) session.getValue("lien");
    try {
        UserEJB ue = (UserEJB) session.getValue("u");
        MapUtilisateur u = ue.getUser();
        String receiver = u.getTeluser();
        MapUtilisateur map = ue.getUser();
        String awhere = " and receiver='" + receiver + "' ";
        String home_page=ue.getHome_page();
        MapUtilisateur[] u2 = (MapUtilisateur[]) (CGenUtil.rechercher(new MapUtilisateur(), null, null, ""));
%>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        var userSpan = document.getElementById('user-login-span');
        var popup = document.getElementById('custom-popup');
        if (userSpan && popup) {
            userSpan.addEventListener('click', function (e) {
                e.stopPropagation();
                popup.style.display = 'block';
            });
            document.addEventListener('click', function (e) {
                if (!popup.contains(e.target) && e.target !== userSpan) {
                    popup.style.display = 'none';
                }
            });
        }
    });

    function verifEditerTef(et, name){
        if (et < 11){
            alert('Impossible d\'editer Tef. ' + name + ' non vis� ');
        } else{
            document.tef.submit();
        }
    }
    function verifLivraisonBC(et){
        if (et < 11){
            alert('Impossible d effectuer la livraison du bon de commande');
        } else{
            document.tef.submit();
        }
    }
    function CocherToutCheckBox(ref, name) {
        var form = ref;
        while (form.parentNode && form.nodeName.toLowerCase() != 'form') {
            form = form.parentNode;
        }

        var elements = form.getElementsByTagName('input');
        for (var i = 0; i < elements.length; i++) {
            if (elements[i].type == 'checkbox' && elements[i].name == name) {
                elements[i].checked = ref.checked;
            }
        }
    }

</script>
<style type="text/css">
    #custom-popup {
        animation: fadeInPopup 0.25s;
    }
    @keyframes fadeInPopup {
        from { opacity: 0; transform: translateY(-10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .breadcrumb {
        padding-left: 20px;
    }

</style>
<header class="main-header" style="position: fixed; left: 0; right: 0;">
    <!-- Logo -->
    <a style="background-color:#ffffff; height:50px;" href="<%=lien%>?but=<%=home_page%>" class="logo d-none">
        <!-- mini logo for sidebar mini 50x50 pixels -->

        <span class="logo-mini" style="color: <%=Constante.constanteCouleur%>;font-weight: 600;"><img style="width: auto;height: 25px;" src="${pageContext.request.contextPath}/assets/img/logo_sav.png"/></span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg">  <img style="width: auto;height: 25px;" src="${pageContext.request.contextPath}/assets/img/logo_sav.png"/> </span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav style="background:#ffffff;  height: 10px;" class="navbar navbar-static-top" role="navigation">
        <!-- Sidebar toggle button-->
        <button class="sidebar-toggle" style="background:none;border:none;cursor:pointer;color:<%=Constante.constanteCouleur%>"
                data-toggle="offcanvas" role="button" aria-label="Toggle navigation">

            <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 12 13" fill="none">
                <path
                        d="M9.05 8.1828V4.84946C9.05 4.73924 8.99722 4.66446 8.89167 4.62513C8.78611 4.58579 8.69444 4.60502 8.61667 4.6828L7.13333 6.16613C7.03333 6.26613 6.98333 6.3828 6.98333 6.51613C6.98333 6.64946 7.03333 6.76613 7.13333 6.86613L8.61667 8.34946C8.69444 8.42724 8.78611 8.44646 8.89167 8.40713C8.99722 8.3678 9.05 8.29302 9.05 8.1828ZM1 12.5161C0.725 12.5161 0.489611 12.4182 0.293833 12.2223C0.0979445 12.0265 0 11.7911 0 11.5161V1.51613C0 1.24113 0.0979445 1.00568 0.293833 0.809795C0.489611 0.614017 0.725 0.516129 1 0.516129H11C11.275 0.516129 11.5104 0.614017 11.7063 0.809795C11.9021 1.00568 12 1.24113 12 1.51613V11.5161C12 11.7911 11.9021 12.0265 11.7063 12.2223C11.5104 12.4182 11.275 12.5161 11 12.5161H1ZM3.45 11.5161V1.51613H1V11.5161H3.45ZM4.45 11.5161H11V1.51613H4.45V11.5161Z"
                        fill="currentColor" />
            </svg>
        </button>

        <div class="recherche-global col-md-5 " >
            <form action="<%=lien%>" method="GET" >
                <div class="form-input col-md-12 form-input-apj" style="margin-bottom: 0; display: flex; align-items: center;align-items: center;margin-top: 21px;flex-direction: row">
                    <label class="Body14pxRegular" style="margin-right: 10px;white-space: nowrap;">Recherche Globale</label>
                    <input value="recherche-global.jsp" name="but" type="hidden">
                    <div style="position: relative; flex: 1;">
                        <input name="remarque" type="text" class="form-control global-search-input" style="height: 28px; padding-right: 30px;"
                               onkeydown="if(event.key === 'Enter'){ event.preventDefault(); this.form.submit(); }">
                        <span onclick="this.parentNode.querySelector('input[name=remarque]').form.submit();" style="position: absolute; right: 8px; top: 50%; transform: translateY(-50%); color: #aaa;display: flex">
                                    <i class="material-symbols-rounded">search</i>
                                </span>
                    </div>
                </div>
                <!-- <button class="btnheight" type="submit" >
                    <i class="fa fa-search" aria-hidden="true"></i>
                </button> -->
            </form>
        </div>
        <div class="navbar-custom-menu">
            <ul class="nav navbar-nav">
                <!-- Notifications -->
                <li class="dropdown user user-menu" id="notifrefresh" style="display: flex; align-items: center; margin-right: 20px;">
                    <!-- notification.js va injecter l'icône et dropdown -->
                </li>
                <!-- User Account: style can be found in dropdown.less -->
                <li class="dropdown user user-menu" style="display: flex; align-items: center; margin: 20px; position: relative;">
                            <span style="display: flex; align-items: center; cursor: pointer;" id="user-login-span">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 12 12" fill="none" style="margin-right: 6px;">
                                    <path
                                            d="M5.99984 6C7.47317 6 8.6665 4.80667 8.6665 3.33333C8.6665 1.86 7.47317 0.666666 5.99984 0.666666C4.5265 0.666666 3.33317 1.86 3.33317 3.33333C3.33317 4.80667 4.5265 6 5.99984 6ZM5.99984 7.33333C4.21984 7.33333 0.666504 8.22667 0.666504 10V11.3333H11.3332V10C11.3332 8.22667 7.77984 7.33333 5.99984 7.33333Z"
                                            fill="#1C1F21" />
                                </svg>
                                <span class="hidden-xs" style="color:<%=Constante.constanteCouleur%>"><%=map.getLoginuser()%></span>
                            </span>
                    <div id="custom-popup" style="display:none; position:absolute; top:40px; right:0; min-width:180px; background:#fff; box-shadow:0 8px 24px rgba(0,0,0,0.18); border-radius:10px; z-index:9999; padding:18px 16px;">
                        <a href="deconnexion.jsp" class="btn btn-primary" style="width:100%;box-shadow:0 2px 8px rgba(25,118,210,0.12);border-radius:6px;">D&eacute;connexion</a>
                    </div>
                </li>
            </ul>
        </div>
    </nav>

</header>
<div class="modal fade" id="modalSendMessage" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="message-chat-title"></h4>
            </div>
            <div class="modal-body clearfix">
                <div class="message-chat-content clearfix" id="message-chat-content">

                </div>
                <br/>
                <form>
                    <textarea id="messagefrom" onkeypress="keypressedsendMessage(this, 1)" class="form-control" rows="3" placeholder="Votre message ici" ></textarea>
                    <br/><br/>
                    <input type="button" class="btn btn-primary pull-right" style="margin-left: 5px;" onclick="keypressedsendMessage(this, 2)" value="Envoyer"/>
                    <input type="reset" class="btn btn-danger pull-right" value="Annuler"/>
                </form>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalSendMessageTo" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="min-height: 200px">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <ul  > <%
                    for (MapUtilisateur utilisateur : u2) {%>
                    <li class="fa fa-envelope-o ">
                        <a href="module.jsp?but=notification/message-envoi.jsp&to=<%=utilisateur.getTeluser()%>"> <%=utilisateur.getNomuser()%></a>

                    </li><br/>
                    <%}
                    %>
                </ul>
            </div>

        </div>
    </div>
</div>

<%
    } catch (ConcurrentAccessTimeoutException e) {
        out.println("<script language='JavaScript'> document.location.replace('/cnaps-war/');</script>");
    }
%>
<script src="${pageContext.request.contextPath}/apjplugins/notification.js" type="text/javascript"></script>