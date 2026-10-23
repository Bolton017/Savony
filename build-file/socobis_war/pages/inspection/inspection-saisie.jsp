<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsertMultiple"%>
<%@ page import="user.UserEJB" %>
<%@ page import="machine.InspectionMere" %>
<%@ page import="machine.InspectionFille" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.TypeObjet" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String classeMere = "machine.InspectionMere";
    String classeFille = "machine.InspectionFille";
    String nomTableFille = "INSPECTIONFILLE";
    String colonneMere = "idmere";
    String apres = "inspection/inspection-fiche.jsp";

    InspectionMere mere = new InspectionMere();
    mere.setNomTable("INSPECTIONMERE");
    InspectionFille fille = new InspectionFille();
    fille.setNomTable("INSPECTIONFILLE");
    int taille = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, taille, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'une inspection");


    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("heure").setLibelle("Heure");
    pi.getFormu().getChamp("idinspecteur").setLibelle("Inspecteur");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("heure").setDefaut(Utilitaire.heureCouranteHM());

    pi.getFormu().getChamp("idinspecteur").setPageAppelComplete("personnel.Personnel","id","Personnel","","");
    Liste[] liste = new Liste[1];
    liste[0] = new Liste("idelement",new maintenance.ressources.IngredientMaintenance(),"libelle","id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("idelement").setLibelle("Element");

    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    Liste[] liste2 = new Liste[1];
    TypeObjet typeEtat = new TypeObjet();
    typeEtat.setNomTable("ETATINSPECTION");
    liste2[0] = new Liste("idEtatInspection",typeEtat,"val","id");
    pi.getFormufle().changerEnChamp(liste2);

    Champ.setPageAppelCompleteAWhere(pi.getFormufle().getChampFille("idelement"),"machine.ElementInspectionMachineLib","element","ElementInspectionMachineLib","","","");
    pi.getFormufle().getChamp("idEtatInspection_0").setLibelle("&Eacute;tat de l'inspection");
    pi.getFormufle().getChamp("idelement_0").setLibelle("Element");

    Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
    Champ.setVisible(pi.getFormufle().getChampMulitple("etatinspection").getListeChamp(),false);
    // Hide primary key column in the fille table
    pi.getFormufle().getChampMulitple("id").setVisible(false);

    // Force column order so the etat inspection select is shown in the fille rows
    String[] colOrdre = {"idelement","idEtatInspection","remarque"};
    pi.getFormufle().setColOrdre(colOrdre);

    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'une inspection");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form id="formId" class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getFormufle().getHtmlTableauInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=classeMere%>">
        <input name="classefille" type="hidden" id="classefille" value="<%=classeFille%>">
        <input name="nomtable" type="hidden" id="nomtable" value=<%=nomTableFille%>>
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=taille%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%=colonneMere%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
