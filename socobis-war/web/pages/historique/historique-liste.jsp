
<%@page import="affichage.PageRecherche"%>
<%@page import="produits.*"%>

<% try{
    Historique t = new Historique();
    t.setNomTable("Historique");
    String listeCrt[] = {"datehistorique","refobjet"};
    String listeInt[] = {"datehistorique"};
    String libEntete[] = {"idhistorique","datehistorique","heure","action","idutilisateur","objet","refobjet"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des historiques");
    pr.getFormu().getChamp("refobjet").setLibelle("R&eacute;f&eacute;rence Objet");
    pr.getFormu().getChamp("datehistorique1").setLibelle("Date min");
    pr.getFormu().getChamp("datehistorique2").setLibelle("Date max");
    pr.getFormu().getChamp("datehistorique1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datehistorique2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("historique/historique-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID Historique","Date","Heure","Action","Utilisateur","Objet","R&eacute;f&eacute;rence Objet"};
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
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



