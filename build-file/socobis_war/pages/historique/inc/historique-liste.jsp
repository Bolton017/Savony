
<%@page import="affichage.PageRecherche"%>
<%@page import="produits.*"%>

<% try{
    Historique t = new Historique();
    t.setNomTable("historiqueAvecUser");
    String listeCrt[] = {"datehistorique","refobjet"};
    String listeInt[] = {"datehistorique"};
    String libEntete[] = {"idhistorique","datehistorique","heure","action","idutilisateur","objet","refobjet"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    //pr.setAWhere(" and refObjet='"+request.getParameter("id")+"'");
    pr.setTitre("Liste des historiques");
    pr.getFormu().getChamp("refobjet").setLibelle("R&eacute;f&eacute;rence Objet");
    pr.getFormu().getChamp("refobjet").setDefaut(request.getParameter("id"));
    pr.getFormu().getChamp("datehistorique1").setLibelle("Date min");
    pr.getFormu().getChamp("datehistorique2").setLibelle("Date max");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("historique/historique-liste.jsp");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"Ref. Historique","Date","Heure","Action","Utilisateur","Objet","R&eacute;f&eacute;rence Objet"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">        <%
            out.println(pr.getTableau().getHtml());
            //out.println(pr.getBasPage());
        %>

</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



