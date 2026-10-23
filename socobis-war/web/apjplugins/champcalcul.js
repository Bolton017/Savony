function calculer(id){
	var input = document.getElementById(id);
	var calcul = input.value.replace(/\s/g, '').replace(/,/g, '.');
	var debutcalcul = calcul.substring(0,1);
	var operation = calcul.substring(1, calcul.length);
	if(debutcalcul === '=') {
		var resultat = effectuerOperation(operation, 0);
		var resultatFormate = formaterNombre(resultat);
		input.value = resultatFormate;
	}
}

function formaterNombre(nombre){
	if(isNaN(nombre)) return nombre.toString();

	var estEntier = nombre % 1 === 0;
	var partieEntiere = Math.abs(Math.floor(nombre));
	var partieDecimale = Math.abs(nombre) - partieEntiere;
	var signe = nombre < 0 ? '-' : '';

	var partieEntiereStr = partieEntiere.toString();
	var partieEntiereFormatee = partieEntiereStr.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');

	var valeurFormatee = signe + partieEntiereFormatee;
	if(!estEntier && partieDecimale > 0.0001) {
		var decimaleStr = partieDecimale.toFixed(2).substring(1);
		decimaleStr = decimaleStr.replace('.', ',');
		valeurFormatee += decimaleStr;
	}

	return valeurFormatee;
}

function formaterAvecSeparateurMillier(input){
	var valeur = input.value;
	if(valeur === '' || valeur === null) return;

	var valeurSansEspace = valeur.replace(/\s/g, '');
	if(valeurSansEspace.charAt(0) === '=') {
		return;
	}
	// on ne reformate que les saisies numeriques : chiffres, signe, virgule ou point
	if(!/^-?[\d.,]*$/.test(valeurSansEspace)) {
		return;
	}

	var cursorPosition = input.selectionStart;
	var caracteresNonEspaceAvant = valeur.substring(0, cursorPosition).replace(/\s/g, '').length;

	// on travaille sur le texte saisi (et non sur parseFloat) pour garder la virgule et les decimales tapees
	var signe = '';
	if(valeurSansEspace.charAt(0) === '-') {
		signe = '-';
		valeurSansEspace = valeurSansEspace.substring(1);
	}
	var positionVirgule = valeurSansEspace.search(/[.,]/);
	var partieEntiereStr = positionVirgule === -1 ? valeurSansEspace : valeurSansEspace.substring(0, positionVirgule);
	var partieEntiereFormatee = partieEntiereStr.replace(/\B(?=(\d{3})+(?!\d))/g, ' ');

	var valeurFormatee = signe + partieEntiereFormatee;
	if(positionVirgule !== -1) {
		valeurFormatee += ',' + valeurSansEspace.substring(positionVirgule + 1).replace(/[.,]/g, '');
	}

	if(valeurFormatee === input.value) {
		return;
	}

	input.value = valeurFormatee;

	var compteur = 0;
	var nouvellePosition = 0;
	for(var i = 0; i < valeurFormatee.length && compteur < caracteresNonEspaceAvant; i++) {
		if(valeurFormatee.charAt(i) !== ' ') {
			compteur++;
		}
		nouvellePosition = i + 1;
	}

	input.setSelectionRange(nouvellePosition, nouvellePosition);
}

function effectuerOperation(operation, niveau){
	var operateurs = ['+', '-', '*', '/'];
	var sousoperation = operation.split(operateurs[niveau]);
	if(isNaN(operation)){
		resultat = effectuerOperation(sousoperation[0], niveau+1);
		for(var i = 1 ; i < sousoperation.length ; i++){
			if(niveau === 0)
				resultat += effectuerOperation(sousoperation[i], niveau+1);
			if(niveau === 1)
				resultat -= effectuerOperation(sousoperation[i], niveau+1);
			if(niveau === 2)
				resultat *= effectuerOperation(sousoperation[i], niveau+1);
			if(niveau === 3)
				resultat /= effectuerOperation(sousoperation[i], niveau+1);
		}
		return resultat;
	} else
		return parseFloat(operation);
}