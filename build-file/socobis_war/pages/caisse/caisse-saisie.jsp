


<%@page import="mg.cnaps.compta.ComptaCompte"%>
<%@page import="magasin.Magasin"%>
<%@page import="caisse.Caisse"%>
<%@page import="caisse.CategorieCaisse"%>
<%@page import="caisse.TypeCaisse"%>
<%@page import="annexe.Point"%>
<%@page import="affichage.PageInsert"%> 
<%@page import="user.UserEJB"%>
<%@page import="affichage.Liste"%>

<%
    try{
    String autreparsley = "data-parslsey-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "caisse.Caisse",
            nomtable = "caisse",
            apres = "caisse/caisse-fiche.jsp",
            titre = "Insertion de tr&eacute;sorerie";

    Caisse  caisse = new Caisse();
    PageInsert pi = new PageInsert(caisse, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("val").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    pi.getFormu().getChamp("Etat").setVisible(false);
//    pi.getFormu().getChamp("idTypeBanque").setVisible(false);

    Liste[] liste = new Liste[5];
        TypeCaisse type = new TypeCaisse();
        type.setNomTable("TYPECAISSE");
        liste[0] = new Liste("idTypeCaisse",type,"val","id");
        Point point = new Point();
        point.setNomTable("point");
        liste[1] = new Liste("idPoint",point,"val","id");
        liste[1].ajouterVide();
        Magasin magasin = new Magasin();
        magasin.setNomTable("magasin2");
        liste[2] = new Liste("idMagasin",magasin,"val","id");
        liste[2].ajouterVide();
        liste[1].setDeroulanteDependante(liste[2],"idPoint","onchange");
        CategorieCaisse categ = new CategorieCaisse();
        categ.setNomTable("CategorieCaisse");
        liste[3] = new Liste("idCategorieCaisse",categ,"val","id");
				ComptaCompte compta = new ComptaCompte();
        compta.setNomTable("COMPTA_COMPTE_LIB");
//        liste[4] = new Liste("compte",compta,"libelle","compte");
//
//        liste[4].setApresW(" and compte like '5%'");


				liste[4] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[4].setDefaut("AR");

        pi.getFormu().getChamp("compte").setPageAppelCompleteAWhere("mg.cnaps.compta.ComptaCompteCpl", "cpt", "COMPTA_COMPTE_LIB", "", "", " and compte like '%: 5%'");

    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("idPoint").setLibelle("Point");
    pi.getFormu().getChamp("idDevise").setLibelle("Devise");
    pi.getFormu().getChamp("idTypeCaisse").setLibelle("Type");
//    pi.getFormu().getChamp("estRib").setVisible(false);
    pi.getFormu().getChamp("IdCategorieCaisse").setLibelle("Cat&eacute;gorie");
    pi.getFormu().getChamp("idMagasin").setLibelle("Magasin");
    pi.preparerDataFormu();
        if(request.getParameter("acte")!=null){
            titre = "Modification caisse";
        }
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>