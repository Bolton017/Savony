    <%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
        <%@page import="java.util.Locale"%>
        <%@page import="java.util.ResourceBundle"%>
        <%@page import="javax.ejb.ConcurrentAccessTimeoutException"%>
        <%@page import="menu.MenuDynamique"%>
        <%@page import="java.util.ArrayList"%>
        <%@page import="mg.cnaps.utilisateur.CNAPSUser"%>
        <%@page import="user.UserEJB"%>

            <%
    HttpSession sess = request.getSession();
    String lang = "fr";
    if (sess.getAttribute("lang") != null) {
        lang = String.valueOf(sess.getAttribute("lang"));
    }
    ResourceBundle RB = ResourceBundle.getBundle("text", new Locale(lang));

    try {
        if (request.getParameter("currentMenu") != null
                && !request.getParameter("currentMenu").isEmpty()) {
            session.setAttribute("currentMenu", request.getParameter("currentMenu"));
        }
        String currentMenu = (String) request.getSession().getAttribute("currentMenu");

        UserEJB u = (UserEJB) session.getAttribute("u");
        CNAPSUser cnapsUser = u.getCnapsUser();

        ArrayList<ArrayList<MenuDynamique>> arbre = null;
        if (session.getAttribute("MENU") == null) {
            arbre = MenuDynamique.getElementMenu(request, u.getUser(), cnapsUser);
            session.setAttribute("MENU", arbre);
        } else {
            arbre = (ArrayList<ArrayList<MenuDynamique>>) session.getAttribute("MENU");
        }
        String logo = u.getMaSociete().getLogoHeader();

%>

        <aside class="main-sidebar">

        <div class="sidebar-icons-panel">
        <div class="sidebar-logo-top mb-5">
        <a href="${pageContext.request.contextPath}/pages/module.jsp?but=accueil.jsp" class="logo-mini" style="color: #103a8e;font-weight: 600;">
        <img style="width: 90%;height: auto;" src="${pageContext.request.contextPath}/<%=logo%>">
        </a>
        </div>
        <%-- Logo footer bas --%>
        <div class="sidebar-logo-bottom">
        <img src="${pageContext.request.contextPath}/assets/img/logo_A.png" alt="logo">
        </div>
        </div>

        <div class="sidebar-submenu-panel" id="sidebarSubmenuPanel">
        <%-- Contenu généré dynamiquement par JS --%>
        </div>

        </aside>

        <%-- Injection des données menu --%>
        <script>
        var MENU_DATA    = <%= MenuDynamique.renderMenuJson(arbre, RB) %>;
        var CURRENT_MENU = "<%= currentMenu != null ? currentMenu : "" %>";
        </script>

        <script src="${pageContext.request.contextPath}/assets/js/sidebar.js"></script>

            <%
    } catch (ConcurrentAccessTimeoutException e) {
        out.println("<script>document.location.replace('/socobis/');</script>");
    }
%>