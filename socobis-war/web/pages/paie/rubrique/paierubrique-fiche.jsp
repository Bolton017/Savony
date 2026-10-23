
<%@page import="affichage.PageConsulte"%>
<%@page import="user.UserEJB"%>
<%@page import="paie.employe.PaieRubriqueLib"%>
<%@ page import="constante.ConstanteEtat" %>

<%
    String tab = null, id = "";

    try {
        id = request.getParameter("id");

        UserEJB u = (UserEJB) session.getAttribute("u");
        PaieRubriqueLib paie = new PaieRubriqueLib();
        paie.setNomTable("paie_rubrique_fiche");
        PageConsulte pc = new PageConsulte(paie, request, u);
        pc.setTitre("Fiche de la rubrique de paie");

        pc.getChampByName("val").setLibelle("Libell&eacute;");
        pc.getChampByName("desce").setLibelle("Description");
        pc.getChampByName("comptepcg").setLibelle("Compte PCG");
        pc.getChampByName("typerubrique").setLibelle("Type de rubrique");
        pc.getChampByName("bcs").setLibelle("ID");
        pc.getChampByName("afficherlib").setLibelle("Afficher");
        pc.getChampByName("etat").setLibelle("&Eacute;tat");


        pc.getChampByName("afficher").setVisible(false);
        pc.getChampByName("bcs").setVisible(false);
        pc.getChampByName("bg").setVisible(false);
//        pc.getChampByName("avantage").setVisible(false);
        pc.getChampByName("isinfini").setLibelle("Nature");

        pc.getChampByName("cpt_gen_db").setVisible(false);
        pc.getChampByName("cpt_gen_cr").setVisible(false);
        pc.getChampByName("cpt_ana_db").setVisible(false);
        pc.getChampByName("cpt_ana_cr").setVisible(false);
        pc.getChampByName("formule").setVisible(false);


//        pc.getChampByName("cpt_gen_db").setLibelle("Compte general d?bit");
//        pc.getChampByName("cpt_gen_cr").setLibelle("Compte general cr?dit");
//        pc.getChampByName("cpt_ana_db").setLibelle("Compte anal d?bit ");
//        pc.getChampByName("cpt_ana_cr").setLibelle("Compte anal cr?dit");

        paie=(PaieRubriqueLib)pc.getBase();
        id=paie.getId();


%>


<div class="content-wrapper">
    <h1> <%=pc.getTitre()%></h1>
    <div class="row m-0">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                            <%if(paie.getEtat()< ConstanteEtat.getEtatValider()){%>
                                <div class="box-footer" >
                                    <a class="btn btn-primary pull-right" href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&classe=paie.employe.PaieRubrique&nomtable=paie_rubrique&bute=paie/rubrique/paierubrique-fiche.jsp&id=" + id%>" style="margin-right: 10px">Viser</a>
                                    <a class="btn btn-secondary pull-right" href="<%=(String) session.getValue("lien") + "?but=paie/rubrique/paierubrique-modif.jsp&id=" + id%>" style="margin-right: 10px">Modifier</a>
                                </div>
                            <%}%>
                            <br/>

                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
  %>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
