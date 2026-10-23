<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.PageConsulte" %>
<%@ page import="notification.Notification" %>
<%@ page import="constante.ConstanteEtat" %>

<% try{ 
    UserEJB u = (user.UserEJB)session.getValue("u");
    String lien = (String) session.getValue("lien");
    Notification o = new Notification();
    o.setNomTable("NOTIFICATIONLIBCPLT");
    PageConsulte pc = new PageConsulte(o, request, u);
    o = (Notification) pc.getBase();
    pc.setTitre("Fiche de notification");
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("message").setLibelle("Message");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("heure").setLibelle("Heure");
    pc.getChampByName("ecartdate").setLibelle("&Eacute;cart date");
    pc.getChampByName("receiverlib").setVisible(false);
    pc.getChampByName("receiver").setVisible(false);
    pc.getChampByName("etat").setVisible(false);

    String pageRetour = "notification/notification-liste.jsp";
    String pageApresDelete = "notification/notification-liste.jsp";
    String classe = "notification.Notification";

%>

<div class="content-wrapper">
    <h1 class="box-title"><a href=<%= lien + "?but=" + pageRetour%>> <i class="fa fa-angle-left"></i></a><%=pc.getTitre()%></h1>

    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <div class="box-footer">
                            <a class="btn btn-danger pull-left" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageApresDelete+"&classe="+classe %>">Supprimer</a>
                            <% if (o.getEtat() == ConstanteEtat.getEtatCreer()) { %>
                                <a class="btn btn-secondary pull-right" href="<%= lien + "?but=notification/apresnotif.jsp&acte=vu&id=" + id+"&bute=notification/notification-fiche.jsp&classe=utils.Notification&ref="+o.getId() %>">Marquer comme Lu</a>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll("a[href]").forEach(function (a) {
            var href = a.getAttribute("href");
            if (href.startsWith("'") && href.endsWith("'")) {
                a.setAttribute("href", "module.jsp" + href.slice(1, -1));
            }
        });
    });
</script>
<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

