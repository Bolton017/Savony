
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="vente.VenteLib" %>

<% try{
    VenteLib bc = new VenteLib();
    bc.setNomTable("ventecalendrier");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "designation","idClientLib","idDevise","daty","montantttc","montantRevient","margeBrute","montantpaye", "montantreste","etatlib","datyprevu"};
    String libEnteteAffiche[] = {"id", "D&eacute;signation","Client","devise","Date","Montant TTC","Montant de revient","marge Brute","Montant Pay&eacute;","Montant restant","&Eacute;tat","&Eacute;ch&eacute;ance"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/vente-liste.jsp");
    String[] colSomme = { "montantreste" };

    String daty = request.getParameter("daty");

    String awhere = "";
    String titre = "Liste des Factures";
    if (daty!=null){
        awhere = " and datyprevu = TO_DATE('"+daty+"','DD/MM/YYYY')";
        titre+= "du "+daty;
    }

    pr.setAWhere(awhere);
    pr.setTitre(titre);
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/vente-modif.jsp");
    lienTab.put("Voir fiche",pr.getLien() + "?but=vente/vente-fiche.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/inc/vente-details.jsp&id=");
    //pr.getTableau().setModalOnClick(true);
%>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
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
