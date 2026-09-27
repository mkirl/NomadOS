{ ... }: {
  flake.nixosModules.ollama = { pkgs, ... }: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      loadModels = [ "qwen3.5:9b" ];
      environmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_FLASH_ATTENTION = "1";
      };
    };

    environment.systemPackages = [ pkgs.ollama-cuda ];
  };
}
