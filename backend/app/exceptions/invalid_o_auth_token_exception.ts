import { Exception } from "@adonisjs/core/exceptions";

export default class InvalidOAuthTokenException extends Exception {
	static status = 401;
	static code = "E_INVALID_OAUTH_TOKEN";
	static message = "Invalid Oauth token provided.";
}
