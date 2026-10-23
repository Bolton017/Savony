
<%@page import="charge.*"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="bean.AdminGen" %>

<% try{
    Charge bc = new Charge();
    bc.setNomTable("charge_cpl");
    String lien = (String) session.getValue("lien");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "daty", "libelle","typelib","qte","pu","montant","etatlib"};
    String libEnteteAffiche[] = {"Id", "Date", "Libell&eacute;","Type de charge","Quantit&eacute;","Prix unitaire","Montant","&Eacute;tat"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-hs");
    String[] colSomme = null;

    if(request.getParameter("id") != null){
        pr.setAWhere(" and idfabrication='"+request.getParameter("id")+"'");
    }

    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    String bute="fabrication/charge/charge-fiche.jsp";
    lienTab.put("Viser-id",pr.getLien() + "?but=apresTarif.jsp&acte=valider&nomtable=CHARGE&classe=charge.Charge&bute="+bute);
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().transformerDataString();

    String lienTableau[] = {pr.getLien() + "?but=fabrication/charge/charge-fiche.jsp"};
    String colonneLien[] = {"id"};
    String colonneModal[] = {"id"};
    String[] attributLien = {"id","id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setColonneModal(colonneModal);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setModalOnClick(true,colonneModal);
    pr.getTableau().setAfficheBouttondevalider(false);
    pr.getTableau().setNameBoutton("Valider");
    Charge[] liste=(Charge[]) pr.getTableau().getData();
%>

<% if(pr.getTableau().getHtmlWithCheckbox()!=null){ %>
<div class="box-body">
    <section class="">
        <form action="<%= pr.getLien() + "?but=apresMultiple.jsp"%>" method="post" >
            <input name="classe" type="hidden" id="classe" value="charge.Charge">
            <input name="nomtable" type="hidden" id="nomtable" value="CHARGE">
            <input name="acte" type="hidden" id="acte" value="validerMultiple">
            <input type="hidden" name="bute" value="<%= pr.getLien() + "?but=fabrication/fabrication-fiche.jsp&id="+request.getParameter("id")+"&tab=inc/fabrication-charge" %>">
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
    </section>
</div>
<div class="w-100" style="display: flex; flex-direction: row-reverse;">
    <table style="width: 20%"class="table">
        <tr>
            <td><b>Totale HS: </b></td>
            <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(liste,"montant")) %></b></td>
        </tr>
    </table>
</div>
<% }else{ %>
<h4>Aucune donn&eacute;e trouv&eacute;e</h4>
<% } %>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>