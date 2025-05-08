import User from "#models/user";
import { OauthService } from "#services/oauth_service";
import { inject } from "@adonisjs/core";
import type { HttpContext } from "@adonisjs/core/http";

@inject()
export default class SessionController {
	constructor(protected oauth: OauthService) {}

	async store({ request }: HttpContext) {
		await this.oauth.verifyGoogleToken("won't work");
		const { email, password } = request.only(["email", "password"]);
		const user = await User.verifyCredentials(email, password);
		const token = await User.accessTokens.create(user);

		return token;
	}
}
