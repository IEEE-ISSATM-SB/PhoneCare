import { IsString, IsNotEmpty } from 'class-validator';

export class UploadProfilePictureDto {
  @IsString()
  @IsNotEmpty()
  profilePicture: string; // This can be a URL or base64 string
}
