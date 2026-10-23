<%@page import="user.UserEJB"%>
<%@page import="bean.*"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="paie.edition.PaieEditionDetails" %>
<%@ page import="affichage.Liste" %>

<% try {
    PaieEditionDetails tiers = new PaieEditionDetails();
    tiers.setNomTable("det_paie_edit_final_pdf_conid");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] ={
            "id","annee","moislib","dateembauche","salaire_de_base","taux","cnaps","imposable",
            "indemnitedepresentationbrut","indemnite_de_transport","irsa","irsanet", "netaprescalcul",
            "reductionpourpersonnesacharge"
    };
    PageRecherche pr = new PageRecherche(tiers, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste edition de paie");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("paie/editions/paieedition-liste.jsp");

    if(request.getParameter("id") != null){
        pr.setAWhere(" and id like '"+request.getParameter("id")+"%'");
    }

    Liste[] liste = new Liste[1];
    liste[0] = new Liste("mois");
    liste[0].makeListeMois();


    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=paie/editions/paieedition-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {
            "id","ann&eacute;e","mois", "date d'embauche", "salaire de base","taux horaire","cnaps","imposables",
            "Indemnit&eacute;s diverses fixes","primes","irsa","irsa NET","NET apr&egrave;s calcul", "Abattements"
    };
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getFormu().changerEnChamp(liste);
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

