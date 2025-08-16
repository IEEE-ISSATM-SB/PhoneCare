import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class RequestResetDto {
  @IsEmail()
  @IsNotEmpty()
  @IsString()
  email: string;
}
