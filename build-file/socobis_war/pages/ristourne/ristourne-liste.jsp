<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="ristourne.*" %>

<%
    try{
        RistourneLib t = new RistourneLib();
        String[] listeCrt = {"id","designation","idclientlib", "daty"};
        String[] listeInt = {"daty"};
        String[] libEntete = {"id","designation","idclientlib", "daty", "etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setTitre("Liste des ristournes");
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        pr.getFormu().getChamp("designation").setLibelle("d&eacute;signation");
        pr.getFormu().getChamp("IdClientlib").setLibelle("Client");
        pr.getFormu().getChamp("daty1").setLibelle("Date min");
        pr.getFormu().getChamp("daty2").setLibelle("Date max");
        pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
        pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
        String[] colSomme = null;
        pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        String colonneModal[] = {"idproduit"};


        String lienTableau[] = {pr.getLien() + "?but=ristourne/ristourne-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);

        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setModalOnClick(true,colonneModal);
        pr.getTableau().setColonneLien(colonneLien);
        String[] libEnteteAffiche =  {"ID","Designation","Client", "Date", "Etat"};
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
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>