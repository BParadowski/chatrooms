import { Exception } from "@adonisjs/core/exceptions";

export default class OAuthEmailUnverifiedException extends Exception {
	static status = 403;
	static code = "E_UNVERIFIED_OAUTH_EMAIL";
	static message = "The email associated with OAuth provider has not been verified.";
}
