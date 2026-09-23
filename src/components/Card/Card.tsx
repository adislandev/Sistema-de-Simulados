import type { HTMLAttributes } from "react";

export default function Card({ className = "", children, ...props }: HTMLAttributes<HTMLDivElement>) {
  return (
    <div className={`bg-surface rounded-md shadow-card p-6 ${className}`} {...props}>
      {children}
    </div>
  );
}
