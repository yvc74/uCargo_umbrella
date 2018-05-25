const emailRegex = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;// Email address

$('.input-emails').tagsInput({
	pattern:  emailRegex,
	placeholderColor: '#9b9b9b',
	removeWithBackspace: false,
	defaultText: 'Correos a los que deseas notificar…'
});