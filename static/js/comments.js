( function() {
	var container = document.querySelector( '[data-comments-id]' );
	if ( !container ) return;

	var commentsId = container.getAttribute( 'data-comments-id' );
	var GH_API_URL = 'https://api.github.com/repos/HunterGerlach/www.huntergerlach.com/issues/' + commentsId + '/comments?per_page=100';

	function sanitizeHTML( raw ) {
		var doc = new DOMParser().parseFromString( raw, 'text/html' );
		doc.querySelectorAll( 'script, iframe, object, embed, form' ).forEach( function( el ) { el.remove(); } );
		doc.querySelectorAll( '*' ).forEach( function( el ) {
			Array.from( el.attributes ).forEach( function( attr ) {
				if ( attr.name.startsWith( 'on' ) ) el.removeAttribute( attr.name );
			} );
			if ( el.tagName === 'A' || el.tagName === 'IMG' ) {
				var val = el.getAttribute( 'href' ) || el.getAttribute( 'src' ) || '';
				if ( val.trimStart().match( /^javascript:/i ) ) {
					el.removeAttribute( 'href' );
					el.removeAttribute( 'src' );
				}
			}
		} );
		return doc.body.innerHTML;
	}

	function safeURL( url, allowedHosts ) {
		try {
			var parsed = new URL( url );
			if ( parsed.protocol !== 'https:' ) return '';
			if ( allowedHosts && allowedHosts.indexOf( parsed.hostname ) === -1 ) return '';
			return parsed.href;
		} catch( e ) { return ''; }
	}

	fetch( GH_API_URL, {
		headers: { 'Accept': 'application/vnd.github.html+json' }
	} )
	.then( function( res ) { return res.json(); } )
	.then( function( comments ) {
		if ( comments.length === 0 ) {
			document.getElementById( 'no-comments-found' ).style.display = 'block';
			return;
		}

		var list = document.getElementById( 'gh-comments-list' );
		comments.forEach( function( c ) {
			list.appendChild( createCommentEl( c ) );
		} );
	} )
	.catch( function( err ) { console.error( err ); } );

	function createCommentEl( c ) {
		var profileURL = safeURL( c.user.url.replace( 'api.github.com/users', 'github.com' ), ['github.com'] );
		var avatarURL = safeURL( c.user.avatar_url, ['avatars.githubusercontent.com'] );
		var commentURL = safeURL( c.html_url, ['github.com'] );

		var user = document.createElement( 'a' );
		if ( profileURL ) user.setAttribute( 'href', profileURL );
		user.classList.add( 'user' );

		var userAvatar = document.createElement( 'img' );
		userAvatar.classList.add( 'avatar' );
		if ( avatarURL ) userAvatar.setAttribute( 'src', avatarURL );
		userAvatar.setAttribute( 'alt', ( c.user.login || 'user' ) + '\'s avatar' );

		user.appendChild( userAvatar );

		var commentLink = document.createElement( 'a' );
		if ( commentURL ) commentLink.setAttribute( 'href', commentURL );
		commentLink.classList.add( 'comment-url' );
		commentLink.textContent = '#' + c.id + ' - ' + c.created_at;

		var commentContents = document.createElement( 'div' );
		commentContents.classList.add( 'comment-content' );
		commentContents.innerHTML = sanitizeHTML( c.body_html );

		var comment = document.createElement( 'li' );
		comment.appendChild( user );
		comment.appendChild( commentContents );
		comment.appendChild( commentLink );

		return comment;
	}
} )();
