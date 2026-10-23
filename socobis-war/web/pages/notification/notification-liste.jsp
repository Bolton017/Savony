<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageRecherche"%>
<%@ page import="notification.Notification" %>
<%@ page import="affichage.Liste" %>
<%@ page import="user.UserEJB" %>

<% try{ 
    Notification o = new Notification();
    o.setNomTable("notificationlibcplt");
    String[] listeCrt = {"message","daty","etat"};
    String[] listeInt = {"daty"};
    String[] libEntete = {"id","message","daty","heure","etatlib"};
    PageRecherche pr = new PageRecherche(o, request, listeCrt, listeInt, 4, libEntete, libEntete.length);
    pr.setTitre("Liste des notifications");
    UserEJB u = (UserEJB) session.getAttribute("u");
    pr.setUtilisateur(u);
    pr.setLien((String) session.getValue("lien"));
    pr.setAWhere(" AND receiver = '"+u.getUser().getTuppleID()+"'");

    Liste[] liste = new Liste[1];
    String[] val = {"%","11","1"};
    String[] aff = {"Tous","Lu","Non Lu"};
    liste[0] = new Liste("etat", aff, val);

    pr.getFormu().changerEnChamp(liste);
    pr.setApres("notification/notification-liste.jsp");
    pr.getFormu().getChamp("message").setLibelle("Message");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String[] lienTableau = {pr.getLien() + "?but=notification/notification-fiche.jsp"};
    String[] colonneLien = {"id"};
    String[] attributLien = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(attributLien);

    String[] libEnteteAffiche = {"Id","Message","Date","Heure","&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

