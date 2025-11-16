import { Component, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './home.component.html',
  styleUrl: './home.component.css'
})
export class HomeComponent {
  echoResult = signal<string | null>(null);
  isCalling = signal(false);

  constructor(private http: HttpClient) {}

  callEcho() {
    if (this.isCalling()) return;
    this.isCalling.set(true);
    this.echoResult.set(null);
    this.http
      .post('/api/echo', { message: 'hello from the frontend' })
      .subscribe({
        next: (data) => {
          this.echoResult.set(JSON.stringify(data, null, 2));
          this.isCalling.set(false);
        },
        error: (err) => {
          const msg = err?.error ? JSON.stringify(err.error, null, 2) : String(err);
          this.echoResult.set(`Error calling /api/echo:\n${msg}`);
          this.isCalling.set(false);
        },
      });
  }
}
