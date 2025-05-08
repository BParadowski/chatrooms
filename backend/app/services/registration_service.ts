import User from "#models/user";
import type { OAuthProviderPayload } from "#services/oauth_service";
import { randomBytes } from "node:crypto";

interface UserRegistrationDetails {
	email: string;
	name: string;
	password: string;
}

export class RegistrationService {
	public async registerUser(data: UserRegistrationDetails): Promise<User> {
		const user = User.create({ fullName: data.name, email: data.email, password: data.password });
		return user;
	}

	public async registerOAuthUser(data: OAuthProviderPayload): Promise<User> {
		const password = this.generateSecurePassword(20);
		const user = User.create({ fullName: data.name, email: data.email, password });
		return user;
	}

	private generateSecurePassword(length = 16): string {
		const chars =
			"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[]{};:,.<>?";
		const bytes = randomBytes(length);
		const password = Array.from(bytes, (byte) => chars[byte % chars.length]).join("");
		return password;
	}
}
