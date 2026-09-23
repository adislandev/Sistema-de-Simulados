import type { InputHTMLAttributes } from "react";

interface FieldProps extends InputHTMLAttributes<HTMLInputElement> {
  label: string;
}

export default function Field({ label, id, className = "", ...props }: FieldProps) {
  return (
    <div className="flex flex-col gap-1.5 mb-4">
      <label htmlFor={id} className="text-sm font-semibold text-ink-soft">
        {label}
      </label>
      <input
        id={id}
        className={`min-h-11 px-3.5 py-3 border border-primary-100 rounded-md text-base bg-surface text-ink focus:outline-2 focus:outline-primary-500 focus:outline-offset-1 ${className}`}
        {...props}
      />
    </div>
  );
}
