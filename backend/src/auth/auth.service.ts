import { Injectable, UnauthorizedException, BadRequestException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
	constructor(
		private readonly usersService: UsersService,
		private readonly jwtService: JwtService,
	) {}

	async register(registerDto: RegisterDto) {
		const { email, password, name } = registerDto;
		const existingUser = await this.usersService.findByEmail(email);
		if (existingUser) {
			throw new BadRequestException('Email already in use');
		}
		const hashedPassword = await bcrypt.hash(password, 10);
		const user = await this.usersService.createUser(email, hashedPassword, name);
		return { email: user.email, name: user.name };
	}

	async login(loginDto: LoginDto) {
		const { email, password } = loginDto;
		const user = await this.usersService.findByEmail(email);
		if (!user) {
			throw new UnauthorizedException('Invalid credentials');
		}
		const isPasswordValid = await bcrypt.compare(password, user.password);
		if (!isPasswordValid) {
			throw new UnauthorizedException('Invalid credentials');
		}
		const payload = { sub: user._id, email: user.email };
		const token = this.jwtService.sign(payload);
		return { access_token: token };
	}
}
