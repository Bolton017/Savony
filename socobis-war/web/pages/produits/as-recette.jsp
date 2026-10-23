<%-- 
    Document   : as-produits-fiche
    Created on : 1 d�c. 2016, 10:40:08
    Author     : Joe
--%>

<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="mg.allosakafo.produits.Recette"%>
<%

	Recette p = new Recette();
	p.setNomTable("as_recette_libelle"); // vue
	String id = request.getParameter("id");
    Recette[] liste = (Recette[]) CGenUtil.rechercher(p, null, null, " and idproduits = '" + id + "'");
	String lien = (String) session.getValue("lien");
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title">Recette</h1>
                    </div>
                    <div class="box-body table-responsive">
					<form action="<%=lien%>?but=produits/apresProduits.jsp" method="post">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>ID</th>
									<th></th>
									<th>Ingredients</th>
                                    <th>Quantit&eacute;</th>
									<th>Unit&eacute;</th>
									<th></th>
                                </tr>
                            </thead>

                            <tbody id="ingredientsListe">
                                <%
                                    for (int i = 0; i < liste.length; i++) {
                                %>
                                <tr id="ingredients-id-<%=i%>" onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
									
                                    <td>
										<input type="text" style="border:none" value="<%=liste[i].getId()%>" name="idIngredients" id="ids<%=i%>"  readonly="true">
									</td>
									<td></td>
									<td><input type="text"  style="border:none" value="<%=liste[i].getIdingredients()%>" id="libs<%=i%>"  name="libs"  readonly="true"> </td>
									<td><input type="text" style="border:none" value="<%=liste[i].getQuantite()%>" id="qte<%=i%>"  name="qte"></td>
									<td><input type="text" style="border:none" value="<%=liste[i].getUnite()%>" id="unite<%=i%>"  name="unite" readonly="true"></td>
									<td><a onclick="removeLineByIndex(<%=i%>)">X</a><input type="hidden" name="actionligne" id="actionligne<%=i%>" value="modif"  readonly="true">
									</td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
						<br>
						<div class="box-footer">
							<input id="taille" name="taille" type="hidden" value="<%=liste.length%>"/>
							<input id="id" name="id" type="hidden" value="<%=id%>"/>
							<input id="bute" name="bute" type="hidden" value="produits/as-recette.jsp"/>
							<input id="nbrLigne" name="nbrLigne" type="hidden" value="<%=liste.length%>"/>
							<input type="button" class="btn btn-default pull-right" value="Ajouter ingredients" onclick="ajouter_ligne()"/>
							<input type="submit" class="btn btn-success pull-right" value="Enregistrer"/>
							<input name="acte" type="hidden" id="nature" value="modifRecette">
                        </div>
                        <br/>
					</form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
	var tailleDefaut = document.getElementById("taille").value,
    nombreLigne = document.getElementById("nbrLigne").value,
    compteur = document.getElementById("nbrLigne").value;
	
    function ajouter_ligne() {
        var html = genererLigneFromIndex (compteur);
        $('#ingredientsListe').append(html);
        compteur ++;
        nombreLigne ++;
        inputNbrLigne();
    }
	function inputNbrLigne() {
        document.getElementById("taille").value = compteur;
		document.getElementById("nbrLigne").value = nombreLigne;
    }

    function removeLineByIndex(index)
    {
        var nomId = "ingredients-id-" + index;

        var ligne = document.getElementById(nomId);
        ligne.style.display = 'none';
		document.getElementById("actionligne"+index).value="supp";
		nombreLigne --;
        inputNbrLigne();
    }
	function genererLigneFromIndex (index)
    {
       var html =  "<tr id=\"ingredients-id-"+index+"\" onmouseover=\"this.style.backgroundColor = '#EAEAEA'\" onmouseout=\"this.style.backgroundColor = ''\">";
	  html += "<td><input type=\"text\"  style=\"border:none\" name=\"idIngredients\" id=\"ids"+index+"\"  readonly=\"true\"></td><td><input name=\"choix1_" + index + "\" type=\"button\" onclick=\"pagePopUp(\'choix/choixIngredients.jsp?champReturn=ids" + index + ";libs"+index+";unite"+index+"\')\" value=\"...\" class=\"submit\"></td>";
	  html += "<td><input type=\"text\" style=\"border:none\" id=\"libs"+index+"\"  name=\"libs\"  readonly=\"true\"></td>";
	  html += "<td><input type=\"text\" style=\"border:none\" id=\"qte"+index+"\"  name=\"qte\"></td>";
	  html += "<td><input type=\"text\" style=\"border:none\" id=\"unite"+index+"\"  name=\"unite\"  readonly=\"true\"></td>";
	  html += "<td><a onclick=\"removeLineByIndex("+index+")\">X</a><input type=\"hidden\"  id=\"actionligne"+index+"\" name=\"actionligne\" value=\"ajout\"></td>";
	   html+= "</tr>";
		return html;
    }
	
</script>