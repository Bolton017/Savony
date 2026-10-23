<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.employe.sanction.SanctionCPL" %>
<%@ page import="affichage.Liste" %>

<% try {
    SanctionCPL s = new SanctionCPL();
    s.setNomTable("SANCTION_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] ={"id", "matricule", "descriptionFaute",
                          "libelleFaute","sanction","daty","dateDebut",
                          "duree","niveauSanction","nompersonnel","reglementLib","numeroRegle"};

    PageRecherche pr = new PageRecherche(s, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste Sanction");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    //pr.setLien((String) session.getValue("lien"));
    //pr.setApres("paie/editions/paieedition-liste.jsp");

    if(request.getParameter("id") != null){
     pr.setAWhere(" and idPersonne like '"+request.getParameter("id")+"%'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=paie/employe/sanction/sanction-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {
            "ID Sanction", "Matricule","D&eacute;scription Faute",
            "Faute","sanction","Date","Date d&eacute;but",
            "dur&eacute;e","Niveau de Sanction","Nom et Pr&eacute;noms","R&egrave;gle","Num&eacute;ro R&egrave;gle"
    };
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<div class="box-body">
    <%
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        }else
        {%>
    <div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }%>
</div>
<script>
    function changerDesignation() {
        document.incident.submit();
    }
</script>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

