import User from "#models/user";
import { OAuthService } from "#services/oauth_service";
import { RegistrationService } from "#services/registration_service";
import { loginValidator } from "#validators/login";
import type { AccessToken } from "@adonisjs/auth/access_tokens";
import { inject } from "@adonisjs/core";
import type { HttpContext } from "@adonisjs/core/http";

@inject()
export default class SessionController {
	constructor(
		protected oauth: OAuthService,
		protected registrationService: RegistrationService
	) {}

	async store({ request }: HttpContext): Promise<AccessToken> {
		console.log(request.body());
		const loginData = await loginValidator.validate(request.body());

		// OAuth case
		if ("provider" in loginData) {
			const providerPayload = await this.oauth.verify(loginData.provider, loginData.idToken);
			const user = await User.findBy({ email: providerPayload.email });

			if (!user) {
				const user = await this.registrationService.registerOAuthUser(providerPayload);
				const token = await User.accessTokens.create(user);
				return token;
			}

			const token = await User.accessTokens.create(user);
			return token;
		}

		// Email and password case
		const { email, password } = loginData;
		const user = await User.verifyCredentials(email, password);
		const token = await User.accessTokens.create(user);

		return token;
	}
}
