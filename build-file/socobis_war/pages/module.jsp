<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="javax.ejb.ConcurrentAccessTimeoutException"%>
<%@page import="user.UserEJB"%>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.ApjSplitView" %>

<%
    try {

        String but = "index.jsp";
        String lien = "module.jsp";
        String lienContenu = "index.jsp";
        String menu = "elements/menu/";
        String langue = "";
        if (request.getParameter("langue") != null) {
            session.setAttribute("langue", (String) request.getParameter("langue"));
        }
        langue = (String) session.getAttribute("langue");
%>
<%@include file="security-login.jsp"%>
<%    if (session.getAttribute("lien") != null) {
        lien = (String) session.getAttribute("lien");
    }
    if (request.getParameter("idmenu") != null) {
        session.setAttribute("lien", lien);
        session.setAttribute("menu", (String) request.getParameter("idmenu"));
    }
    if ((request.getParameter("but") != null) && session.getAttribute("u") != null) {
        but = request.getParameter("but");
    } else {%>
<script language="JavaScript">
    alert("Veuillez vous connecter pour acceder a ce contenu");
    document.location.replace("${pageContext.request.contextPath}/index.jsp");
</script>
<% }
%>

<!DOCTYPE html>
<html>
    <head>
        <!--<meta charset="UTF-8">-->
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-15">
        <title>ERP-Prospection</title>
        <!-- Tell the browser to be responsive to screen width -->
        <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
        <jsp:include page='elements/css.jsp'/>
        <%=ApjSplitView.getCSS()%>
        <script type="module" src="${pageContext.request.contextPath}/assets/js/breadcrumb/breadcrumb.js"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/img/favicon.png">
        <script src="${pageContext.request.contextPath}/dist/js/chart.js"></script>
    </head>
    <body class="skin-yellow-light sidebar-mini">
        <!-- Loader  -->
        <div id="loader" style="display: none;" class="loading-state">
            <div class="loading"></div>
        </div>

        <!-- Site wrapper -->
        <div class="wrapper" style="max-width:none !important;padding: 0 !important;">
            <!-- Header -->
            <jsp:include page='elements/header.jsp'/>
            <!-- =============================================== -->
            <!-- chatbot -->
            <jsp:include page='Chatbot/chat.jsp'/>
            <!-- Menu Gauche -->
            <jsp:include page='elements/menu/module.jsp'/>
            <!-- =============================================== -->
            <!-- Content -->
            <% try {%>
            <div id="butjsp"> <jsp:include page="<%=but%>"/></div>
            <!-- Modal d'apercu de fichier partage : fournit openPreview() a toutes les pages -->
            <jsp:include page='elements/apercu-fichier.jsp'/>
            <% } catch (Exception e) {
                e.printStackTrace();
            %>
            <script language="JavaScript"> alert('<%=e.getMessage().toUpperCase()%>');
                history.back();</script>
                <%
                    }
                %>
            <!-- =============================================== -->
            <!-- Footer -->
            <jsp:include page='elements/footer.jsp'/>
            <!-- =============================================== -->
            <!-- Panel -->
<%--            <jsp:include page='elements/panel.jsp'/>--%>
            <!-- =============================================== -->
        </div>
        <!-- ./wrapper -->
        <jsp:include page='elements/js.jsp'/>
        <script>
            <%
                UserEJB user = (UserEJB) request.getSession().getAttribute("u");
            %>
            runWScommunication('<%=user.getUser().getTuppleID()%>');
        </script>
        <script src="${pageContext.request.contextPath}/apjplugins/champcalcul.js" defer></script>      
        <script src="${pageContext.request.contextPath}/apjplugins/champdate.js" defer></script>      
        <script src="${pageContext.request.contextPath}/apjplugins/champautocomplete.js" defer></script>
        <script src="${pageContext.request.contextPath}/apjplugins/addLine.js" defer></script>
        <script src="${pageContext.request.contextPath}/apjplugins/moreAction.js" defer></script>
        <%=ApjSplitView.getJS()%>
    </body>
    <script>
    </script>
</html>
<%
    } catch (ConcurrentAccessTimeoutException e) {
        out.println("<script language='JavaScript'> document.location.replace('/cnaps-war/');</script>");
    }
%>